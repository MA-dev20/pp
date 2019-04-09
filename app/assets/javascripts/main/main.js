/*
 *= require jquery3
 *= require main/typed.min
 *= require main/wow
 *= require main/scrollspy
 *= require main/jquery.scrollme
 *= require main/bootstrap.bundle.min
 *= require main/script
 *= require cable
 */

$("#loginForm").on("submit", function(e){
  e.preventDefault()
  var email = $("#loginEmail").val(),
  password = $("#loginPassword").val();
  ajaxLogin(email, password)
})
function ajaxLogin(email, password){
  $(".email-error").hide()
  $(".password-error").hide()
  $.ajax({
    url: '/admins/sign_in',
      beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
    data: {admin: {email: email, password: password}},
    type: "POST", 
    success: function(res){
      if(res.response == "error"){
        if(res.errors.email)
         $(".email-error").show()
        if(res.errors.password)
         $(".password-error").show()
      }else{
      	window.location.href = "/admin/dash"
      }
    }
  });
}