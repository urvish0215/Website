<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*,java.nio.*,java.security.*,java.nio.charset.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
  <%
    try {
      //initialize connection
      ApplicationDB db = new ApplicationDB();
      Connection con = db.getConnection();

      //get form data
      String email = request.getParameter("email");
      String rawpass = request.getParameter("password");
      
      String hashs = "SELECT salt, hash FROM User INNER JOIN Authentication on User.uuid = Authentication.uuid WHERE user.email = ?";
      PreparedStatement hashps = con.prepareStatement(hashs);
      ResultSet hashrs = hashps.executeQuery();
      if (hashrs.next()) {
    	  String salt = hashrs.getString(1);
          MessageDigest digest = MessageDigest.getInstance("SHA-256");
          byte[] hash = digest.digest((rawpass.concat(salt)).getBytes(StandardCharsets.UTF_8));
          String encoded = Base64.getEncoder().encodeToString(hash);
          String storedHash = hashrs.getString(2);
          if (encoded.equals(storedHash)) {
        	  out.print("Logged in successfully.");
          } else {
        	  out.print("Incorrect email or password.");
          }
      } else {
    	  out.print("Incorrect email or password.");
      }
      
      con.close();
      
    } catch (Exception e) { }
  %>

</body>
</html>
