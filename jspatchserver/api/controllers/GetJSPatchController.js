/**
 * GetJSPatchController
 *
 * @description :: Server-side logic for managing getjspatches
 * @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers
 */

var fs = require('fs');
var crypto = require('crypto');
var path = require('path');
var _ = require('underscore');
var ursa = require('ursa');
var privatePem = fs.readFileSync(path.dirname()+'/patch/pem/private_key.pem');
var key = privatePem.toString();

module.exports = {
  // js文件路径和命名方式 项目目录/patch1.0.0.js 版本号和app名称都不能为空
	getPatch:function(req, res){
    // app版本号
    var version = req.param('version');
    // app名称
    var appName = req.param('appName');

    if(!_.isString(version) || _.isEmpty(version))
    {
       return res.json({code:-1, msg:'version参数错误!'});
    }

    if(!_.isString(appName) || _.isEmpty(appName))
    {
       return res.json({code:-1, msg:'appName参数错误!'});
    }

    var jspath = path.dirname()+'/patch/js/'+appName+'/'+'patch'+version+'.js';

    fs.exists(jspath, function(exsits){
        if(exsits)
        {
          fs.readFile(jspath, 'utf8', function(err, data){
            if(err){
              return res.json({'code':-1, 'msg':'读取文件失败'});
            }

            var md5data = crypto.createHash('md5').update(data, 'utf8').digest('hex');

            var privateKey = ursa.createPrivateKey(key);
            var verify = privateKey.privateEncrypt(md5data, 'utf8', 'base64');
            var response = {'code':0, 'msg':'获取成功', 'verify': verify, 'data':data};
            return res.json(response);
          });
        }
        else{
          return res.json({'code':-1, 'msg':'文件不存在'});
        }
    });
  }
};

