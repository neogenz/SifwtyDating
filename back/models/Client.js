'use strict';

var _ = require('underscore'),
  bcrypt = require('bcrypt');

function Client(email, username, password) {

  if (_.isNull(email) || _.isNull(username) || _.isNull(password)) {
    throw err('Parameters can\'t be null');
  } else if (_.isUndefined(email) || _.isUndefined(username) || _.isUndefined(password)) {
    throw err('Parameters can\'t be undefined');
  }

  this.id = null;
  this.email = email;
  this.username = username;
  this.password = password;
}

Client.prototype.hashPassword = _hashPassword;
Client.prototype.validPassword = _validPassword;

function _hashPassword(password) {
  return bcrypt.hashSync(password, bcrypt.genSaltSync(8), null);
}

function _validPassword(password) {
  return bcrypt.compareSync(password, this.password);
}


module.exports = Client;
