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
      Boolean success = false;

      //get form data, salt, and uuid
      String username = request.getParameter("username");
      String email = request.getParameter("email");
      String rawpass = request.getParameter("password");
      UUID uuid = UUID.randomUUID();
      String salt = UUID.randomUUID().toString();

      //convert uuid to binary representation
      byte[] uuidBytes = new byte[16];
      ByteBuffer.wrap(uuidBytes)
        .order(ByteOrder.BIG_ENDIAN)
        .putLong(uuid.getMostSignificantBits())
        .putLong(uuid.getLeastSignificantBits());

      //hash the password+salt; in this case just sha-256 so as to not need an external library
      MessageDigest digest = MessageDigest.getInstance("SHA-256");
      byte[] hash = digest.digest((rawpass.concat(salt)).getBytes(StandardCharsets.UTF_8));
      String encoded = Base64.getEncoder().encodeToString(hash);
      

      //check if a user already exists with the given email
      String checkEmailExists = "SELECT COUNT(*) FROM User WHERE email_address = ?";
      PreparedStatement eps = con.prepareStatement(checkEmailExists);
      eps.setString(1, email);
      ResultSet ers = eps.executeQuery();
      
      ers.first();
      
      //check if a user already exists with the given username
      String checkNameExists = "SELECT COUNT(*) FROM User WHERE username = ?";
      PreparedStatement nps = con.prepareStatement(checkNameExists);
      nps.setString(1, username);
      ResultSet nrs = nps.executeQuery();
      
      nrs.first();
      
      
      //if not, create a new user
      if (ers.getInt(1) == 0 && nrs.getInt(1) == 0) {

        String insertUsers = "INSERT INTO User (uuid, username, email_address, push) VALUES (?, ?, ?, ?)";
        String insertAuth = "INSERT INTO Authentication (uuid, salt, pass_hash) VALUES (?, ?, ?)";

        PreparedStatement ups = con.prepareStatement(insertUsers);
        PreparedStatement aps = con.prepareStatement(insertAuth);

        ups.setBytes(1, uuidBytes);
        ups.setString(2, username);
        ups.setString(3, email);
        ups.setBoolean(4, true);

        aps.setBytes(1, uuidBytes);
        aps.setString(2, salt);
        aps.setString(3, encoded);
        
        System.out.println(ups.toString());
        System.out.println(aps.toString());

        ups.executeUpdate();
        aps.executeUpdate();

        out.print("Account created successfully");
        success = true;

      } else if (ers.getInt(1) == 1){

        out.print("An account with that email or username already exists!");

      } else if (nrs.getInt(1) == 1) {
    	  out.print("That username is taken");
      }
      con.close();
      if (success) {
          response.setHeader("Refresh", "7;url=login.jsp");
      } else {
          response.setHeader("Refresh", "7;url=signup.jsp"); 
      }
    } 
  	catch (Exception e) {
    	System.out.println(e);
    	out.print("An error has occured. Please try again.");
        response.setHeader("Refresh", "7;url=signup.jsp");
    }
  %>

</body>
</html>
