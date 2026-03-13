/*
 * For counting Chinese length, a Chinese means 2 bytes
 */
String.prototype.getRealLength=function() { return this.replace(/[^\x00-\xff]/g,"aa").length; };
/*
 * For trimming the leading spaces and the trailing spaces
 */
String.prototype.trim=function() { return this.replace(/^\s+|\s+$/g,""); }