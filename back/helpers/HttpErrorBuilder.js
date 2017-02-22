'use strict';

var HTTP_CODE = require('./HTTP_CODE.json');

function HttpErrorBuilder() {
}

HttpErrorBuilder.prototype.buildHttpError = _buildHttpErrorByError;


/**
 * @function _buildHttpError
 * @desc Build an object representing an standard http error
 * @param {{code: number, status: string, message: string}} httpError
 * @param {Error} Error object to get the name and build standard http error
 * @param {string} messageCustom Message overwrite the error and httpError message
 */
function _buildHttpErrorByError(httpError, error, messageCustom) {
  var httpErrorResponse = (!httpError) ? HTTP_CODE.INTERNAL_ERROR_SERVER : httpError;
  if (error) {
    httpErrorResponse.message = error.toString();
  }
  if (messageCustom) {
    httpErrorResponse.message = messageCustom;
  }
  return httpErrorResponse;
}

module.exports = new HttpErrorBuilder();