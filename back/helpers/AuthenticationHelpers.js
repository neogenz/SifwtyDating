'use strict';

var jwt = require('jsonwebtoken'),
  HTTP_CODE = require('./HTTP_CODE.json'),
  httpErrorBuilder = require('./HttpErrorBuilder');

function AuthenticationsHelpers() {
}

AuthenticationsHelpers.prototype.ensureAuthorized = _ensureAuthorized;


/**
 * @function _ensureAuthorized
 * @desc Verify the token passed in request header
 * @param req
 * @param res
 * @param next
 */
function _ensureAuthorized(req, res, next) {
  var bearerToken = null,
    bearerHeader = req.headers.authorization,
    bearer = null;
  if (bearerHeader !== undefined) {
    bearer = bearerHeader.split(' ');
    bearerToken = bearer[1];
    jwt.verify(bearerToken, process.env.JWT_SECRET, function (err, decoded) {
      if (err) {
        var httpError = httpErrorBuilder.buildHttpError(HTTP_CODE.INTERNAL_ERROR_SERVER, err);
        res.status(httpError.code);
        return res.status(httpError.code).send(httpError);
      }
      // if everything is good, save to request for use in other routes
      req.user = decoded;
      next();
    });
  } else {
    var httpError = httpErrorBuilder.buildHttpError(HTTP_CODE.FORBIDDEN, null, 'Veuillez vous authentifier.');
    res.status(httpError.code);
    return res.status(httpError.code).send(httpError);
  }
}

module.exports = new AuthenticationsHelpers();