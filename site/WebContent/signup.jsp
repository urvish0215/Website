<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Auction Site - Login</title>
</head>
<body>
	Signup
	<br>
		<form method="post" action="newUserRequest.jsp">
			<table>
				<tr><td>Email</td><td><input type="text" name="email"></td></tr>
				<tr><td>Username</td><td><input type="text" name="username"></td></tr>
				<tr><td>Password</td><td><input type="password" name="password"></td></tr>
			</table>
			<br>
			<input type="submit" value="submit">
		</form>
	<br>
	Already have an account?
	<br>
		<form method="get" action="login.jsp">
			<br>
			<input type="submit" value="login">
		</form>
</body>
</html>