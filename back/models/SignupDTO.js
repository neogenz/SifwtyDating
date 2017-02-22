'use strict';

var _ = require('underscore');

function SignupDTO(email, username, password) {

  if(_.isNull(email) || _.isNull(username) || _.isNull(password)){
    throw err('Parameters can\'t be null');
  }else if(_.isUndefined(email) || _.isUndefined(username) || _.isUndefined(password)){
    throw err('Parameters can\'t be undefined');
  }

  this.email = email;
  this.username = username;
  this.password = password;
}

module.exports = SignupDTO;
