function login(){

let role = document.getElementById("role").value

if(role=="admin")
window.location="admin_dashboard.html"

else if(role=="teacher")
window.location="teacher_dashboard.html"

else
window.location="student_dashboard.html"

}