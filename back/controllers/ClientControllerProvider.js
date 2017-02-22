'use strict';

function init(provider, db) {

  var clientServiceProvider = require('../services/ClientServiceProvider'),
    httpErrorBuilder = require('../helpers/HttpErrorBuilder'),
  //authenticationHelper = require('../helpers/AuthenticationHelpers'),
    httpCode = require('../helpers/HTTP_CODE.json'),
    SigninDTO = require('../models/SigninDTO'),
    SignupDTO = require('../models/SignupDTO'),
    jwt = require('jsonwebtoken'),
    _ = require('underscore'),
    randomstring = require("randomstring"),
    crypto = require('crypto');


  clientServiceProvider.setDb(db);

  /**
   * Signin function by this body properties :
   * email : String
   * username : String
   * password : String
   * @param req
   * @param res
   * @private
   */
  function _signin(req, res) {
    var signinDTO = new SigninDTO(req.body.email, req.body.password);
    clientServiceProvider.signinBy(signinDTO).then(function (token) {
      if (_.isNull(token)) {
        var httpError = httpErrorBuilder.buildHttpError(httpCode.NOT_FOUND, 'Email, pseudo ou mot de passe introuvable.');
        res.status(httpError.code);
        return res.status(httpError.code).send(httpError);
      }
      res.send({token: token});
    }).catch(function (err) {
      var httpError = httpErrorBuilder.buildHttpError(httpCode.INTERNAL_ERROR_SERVER, err);
      res.status(httpError.code);
      return res.status(httpError.code).send(httpError);
    });
  }


  /**
   * Get an random challenge
   * @param req
   * @param res
   * @private
   */
  function _generateRandomKey(req, res) {
    var client = null,
      challenge = null;
    if (!req.body.email) {
      var httpError = httpErrorBuilder.buildHttpError(httpCode.NOT_FOUND, "Aucun client avec cet email.");
      return res.status(httpError.code).send(httpError);
    }
    clientServiceProvider.findOneByEmail(req.body.email)
      .then(function (clientFinded) {
        if (!clientFinded) {
          var httpError = httpErrorBuilder.buildHttpError(httpCode.NOT_FOUND, "Client introuvable.");
          return res.status(httpError.code).send(httpError);
        }
        client = clientFinded;
        if (client)
          return clientServiceProvider.generateChallengeBy(client);
      })
      .then(function (challengeGenerated) {
        challenge = challengeGenerated;
        return clientServiceProvider.saveOrUpdateChallengeBy(client.email, challenge.token);
      })
      .then(function (token) {
        console.log('Random key : ' + challenge.randomkey);
        res.send({randomkey: challenge.randomkey});
      })
      .catch(function (err) {
        var httpError = httpErrorBuilder.buildHttpError(httpCode.INTERNAL_ERROR_SERVER, err);
        res.status(httpError.code);
        return res.status(httpError.code).send(httpError);
      });
  }


  function _signinByChallengeToken(req, res) {
    if (!req.body.email) {
      var httpError = httpErrorBuilder.buildHttpError(httpCode.NOT_FOUND, "Aucun client avec cet email.");
      return res.status(httpError.code).send(httpError);
    }
    if (!req.body.token) {
      console.error('Token non présent');
      var httpError = httpErrorBuilder.buildHttpError(httpCode.INTERNAL_ERROR_SERVER, "Erreur technique (INVALID_TOKEN).");
      return res.status(httpError.code).send(httpError);
    }
    clientServiceProvider.findOneByEmail(req.body.email)
      .then(function (clientFinded) {
        if (!clientFinded) {
          var httpError = httpErrorBuilder.buildHttpError(httpCode.NOT_FOUND, "Client introuvable.");
          return res.status(httpError.code).send(httpError);
        }
        return clientServiceProvider.verifyChallengeTokenBy(clientFinded.email, req.body.token);
      })
      .then(function (isValid) {
        if (isValid) {
          res.sendStatus(200);
        } else {
          console.log('Token reçu pour l\'authentification différent de celui présent en base.');
          var httpError = httpErrorBuilder.buildHttpError(httpCode.FORBIDDEN, "Adresse mail ou mot de passe invalide.");
          return res.status(httpError.code).send(httpError);
        }
      })
      .catch(function (err) {
        var httpError = httpErrorBuilder.buildHttpError(httpCode.INTERNAL_ERROR_SERVER, err);
        res.status(httpError.code);
        return res.status(httpError.code).send(httpError);
      });
  }


  /**
   * Create the client
   * @param req
   * @param res
   * @private
   */
  function _signup(req, res) {
    var signupDTO = new SignupDTO(req.body.email, req.body.username, req.body.password);
    clientServiceProvider.findOneByEmailOrUsername(req.body.email, req.body.username)
      .then(function (client) {
        if (!_.isNull(client)) {
          var httpError = httpErrorBuilder.buildHttpError(httpCode.INTERNAL_ERROR_SERVER, "Cette utilisateur existe déja.");
          res.status(httpError.code);
          return res.status(httpError.code).send(httpError);
        }
        return clientServiceProvider.signupBy(signupDTO);
      }).then(function (token) {
        if (_.isNull(token)) {
          var httpError = httpErrorBuilder.buildHttpError(httpCode.NOT_FOUND, 'L\'utilisateur existe déja.');
          res.status(httpError.code);
          return res.status(httpError.code).send(httpError);
        }
        res.send({token: token});
      })
      .catch(function (err) {
        var httpError = httpErrorBuilder.buildHttpError(httpCode.NOT_FOUND, err);
        res.status(httpError.code);
        return res.status(httpError.code).send(httpError);
      });
  }

  //provider.post("/signin", _signin);
  provider.post('/signup', _signup);
  provider.post('/randomkey', _generateRandomKey);
  provider.post('/signin', _signinByChallengeToken);


}

module.exports = init;