'use strict';

var _ = require('underscore');

function SigninDTO(email, password) {

  if(_.isNull(email) || _.isNull(password)){
    throw new Error('Parameters can\'t be null');
  }else if(_.isUndefined(email)  || _.isUndefined(password)){
    throw new Error('Parameters can\'t be undefined');
  }

  this.email = email;
  this.password = password;
}

module.exports = SigninDTO;
