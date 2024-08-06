// isAuthenticated.js
function isAuthenticated(req, res, next) {
  if (req.session && req.session.user && req.session.user.isAdmin) {
    return next();
  } else {

    res.redirect('/adminlogin');
  }
}

module.exports = isAuthenticated;
