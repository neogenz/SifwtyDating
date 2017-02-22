'use strict';

//Models
var jwt = require('jsonwebtoken'),
  Promise = require('promise'),
  _ = require('underscore'),
  bcrypt = require('bcrypt'),
  _db = null,
  Client = require('../models/Client'),
  randomstring = require("randomstring"),
  crypto = require('crypto');

function ClientServiceProvider() {
}

ClientServiceProvider.prototype.signinBy = _signinBy;
ClientServiceProvider.prototype.signupBy = _signupBy;
ClientServiceProvider.prototype.findOneByEmail = _findOneByEmail;
ClientServiceProvider.prototype.setDb = _setDb;
ClientServiceProvider.prototype.generateChallengeBy = _generateChallengeBy;
ClientServiceProvider.prototype.saveOrUpdateChallengeBy = _saveOrUpdateChallengeBy;
ClientServiceProvider.prototype.verifyChallengeTokenBy = _verifyChallengeTokenBy;
ClientServiceProvider.prototype.deleteChallengeBy = _deleteChallengeBy;
ClientServiceProvider.prototype.findOneByEmailOrUsername = _findOneByEmailOrUsername;



function _setDb(db) {
  _db = db;
}


/**
 * @function _signinBy
 * @desc Sign an client in application
 * @param {SigninDTO} signinDTO signin object
 */
function _signinBy(signinDTO) {
  return _findOneByEmail(signinDTO.email).then(function (client) {
    if (_.isNull(client)) {
      return Promise.resolve(null);
    }
    try {
      if (!client.validPassword(signinDTO.password)) {
        console.log('Mot de passe incorrect.');
        return Promise.resolve(null);
      }
      var token = jwt.sign(client, process.env.JWT_SECRET, {
        expiresIn: "86400000" // expires in 24 hours
      });
      return token;
    } catch (err) {
      return Promise.reject(err);
    }
  }).catch(function (err) {
    return Promise.reject(err);
  });
}


/**
 * Create a new client if he no exist by email and username
 * @param {SignupDTO} signupDTO
 * @private
 */
function _signupBy(signupDTO) {
  var client = new Client(signupDTO.email, signupDTO.username, signupDTO.password);
  return _findOneBy(signupDTO)
    .then(function (clientFinded) {
      if (clientFinded !== null) {
        console.log('Le client existe déja.');
        return Promise.resolve(null);
      }
      client.password = client.hashPassword(client.password);
      return _save(client);
    })
    .then(function (clientSaved) {
      if (_.isNull(clientSaved)) {
        console.log('Can\'t sign an token with a null client (already existing client maybe, see call stack).');
        return null;
      }
      var token = jwt.sign(clientSaved, process.env.JWT_SECRET, {
        expiresIn: "86400000" // expires in 24 hours
      });
      return token;
    })
    .catch(function (err) {
      return Promise.reject(err);
    });
}


/**
 * @function _findOneBy
 * @desc Get an client by signin DTO
 * @param {SignupDTO} signupDTO
 * @returns {Promise}
 * @private
 */
function _findOneBy(signupDTO) {
  return new Promise(function (resolve, reject) {
    _db.get("SELECT * FROM client WHERE email = $email AND username = $username", {
      $email: signupDTO.email,
      $username: signupDTO.username
    }, function (err, row) {
      if (err) {
        return reject(new Error(err));
      }
      if (_.isUndefined(row)) {
        console.log('Client introuvable.');
        return resolve(null);
      }
      var client = new Client(row.email, row.username, row.password);
      client.id = row.id;
      resolve(client);
    });
  });
}


/**
 * @function _findBy
 * @desc Get an client by email from DB
 * @param {String} email
 * @returns {Promise}
 * @private
 */
function _findOneByEmail(email) {
  return new Promise(function (resolve, reject) {
    _db.get("SELECT * FROM client WHERE email = $email", {
      $email: email
    }, function (err, row) {
      if (err) {
        return reject(new Error(err));
      }
      if (_.isUndefined(row)) {
        console.log('Client introuvable.');
        return resolve(null);
      }
      var client = new Client(row.email, row.username, row.password);
      client.id = row.id;
      resolve(client);
    });
  });
}


/**
 * @function _findOneByEmailOrUsername
 * @desc Get an client by email or username from DB
 * @param {String} email
 * @param {String} username
 * @returns {Promise}
 * @private
 */
function _findOneByEmailOrUsername(email, username) {
  return new Promise(function (resolve, reject) {
    _db.get("SELECT * FROM client WHERE email = $email OR username = $username", {
      $email: email,
      $username: username
    }, function (err, row) {
      if (err) {
        return reject(new Error(err));
      }
      if (_.isUndefined(row)) {
        console.log('Client introuvable.');
        return resolve(null);
      }
      var client = new Client(row.email, row.username, row.password);
      client.id = row.id;
      resolve(client);
    });
  });
}


/**
 * Save client in DB
 * @param {Client} client
 * @private
 */
function _save(client) {
  return new Promise(function (resolve, reject) {
    _db.run("INSERT INTO client (email, username, password) VALUES ($email, $username, $password)", {
      $email: client.email,
      $username: client.username,
      $password: client.password
    }, function (err, row) {
      if (err) {
        console.log(err.message);
        return reject('Une erreur inconnue est survenue.');
      }
      client.id = this.lastID;
      resolve(client);
    });
  });
}


/**
 * Save the challenge temporary in DB.
 * @param {string} email
 * @param {string} token
 * @private
 */
function _saveOrUpdateChallengeBy(email, token) {
  return new Promise(function (resolve, reject) {
    _db.get("SELECT * FROM challenge WHERE email = $email", {
      $email: email
    }, function (err, row) {
      if (err) {
        return reject(new Error(err));
      }
      resolve(row);
    });
  }).then(function (isAlreadyPresent) {
    if (!isAlreadyPresent) {
      _db.run("INSERT INTO challenge (email, token) VALUES ($email, $token)", {
        $email: email,
        $token: token
      }, function (err, row) {
        if (err) {
          return Promise.reject(new Error(err));
        }
        return token;
      });
    } else {
      _db.run("UPDATE challenge SET token = $token WHERE email = $email", {
        $email: email,
        $token: token
      }, function (err, row) {
        if (err) {
          return Promise.reject(new Error(err));
        }
        return token;
      });
    }
  });
}


/**
 * Generate an challenge by password and email of client
 * @param {Client} client
 */
function _generateChallengeBy(client) {
  return new Promise(function (resolve, reject) {
    try {
      var randomString = randomstring.generate();
      var challenge = crypto.createHash('md5').update(randomString + client.email + client.password).digest("hex");
      return resolve({randomkey: randomString, token: challenge});
    } catch (err) {
      return reject(err);
    }
  });
}


/**
 * Get the token of challenge by user email, then remove him
 * @param {string} email
 */
function _verifyChallengeTokenBy(email, token) {
  return new Promise(function (resolve, reject) {
    _db.get("SELECT token FROM challenge WHERE email = $email", {
      $email: email
    }, function (err, row) {
      if (err) {
        return reject(new Error(err));
      }
      if (_.isUndefined(row)) {
        console.log('Challenge introuvable pour l\'email : ' + email + '.');
        return resolve(null);
      }
      return resolve(row.token);
    });
  }).then(function (tokenFinded) {
    if (tokenFinded === token) {
      return _deleteChallengeBy(token);
    } else {
      return false;
    }
  }).catch(function (err) {
    return Promise.reject(err);
  });
}


/**
 * Remove * from challenge by token
 * @param {string} token
 * @private
 */
function _deleteChallengeBy(token) {
  return new Promise(function (resolve, reject) {
    _db.run("DELETE FROM challenge WHERE token = $token", {
      $token: token
    }, function (err) {
      if (err) {
        return reject(new Error(err));
      }
      if (this.changes > 0) {
        resolve(true);
      } else {
        console.error('Aucun challenge trouvé avec le token ' + token + '.');
        return reject('Aucun challenge trouvé avec le token ' + token + '.');
      }
    });
  });
}


module.exports = new ClientServiceProvider();
