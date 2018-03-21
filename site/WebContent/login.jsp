<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Login Page</title>
</head>
<body>
Login
<br>
	<form method="post" action="loginRequest.jsp">
	<table>
	<tr>    
	<td>Email</td><td><input type="text" name="email"></td>
	</tr>
	<tr>
	<td>Password</td><td><input type="password" name="password"></td>
	</tr>
	</table>
	<br>
	<input type="submit" value="submit">
	</form>
<br>
Don't have an account?
<br>
	<form method="get" action="signup.jsp">
	<br>
	<input type="submit" value="signup">
	</form>
</body>
</html>
