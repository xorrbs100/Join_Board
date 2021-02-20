<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO" %> 
<%@ page import="java.io.PrintWriter" %> <!-- 자바스크립트문을 작성하기 위해 사용 -->
<% request.setCharacterEncoding("UTF-8"); %> <!-- 모든 데이터를 UTF-8로 받음 -->
<jsp:useBean id="user" class="user.User" scope="page" /> 
<!-- id="빈이름", class="패키지.클래스명", scope="유효범위" page = 현재의 페이지에서만 사용 -->

<jsp:setProperty name="user" property="userID" />
<jsp:setProperty name="user" property="userPassword" />
<jsp:setProperty name="user" property="userName" />
<jsp:setProperty name="user" property="userGender" />
<jsp:setProperty name="user" property="userEmail" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판</title>
</head>
<body>

	<%
	String userID=null;
	if(session.getAttribute("userID")!=null){
		userID=(String)session.getAttribute("userID");		
	}
	if(userID!=null){
		PrintWriter script = response.getWriter();
		 script.println("<script>");
		 script.println("alert('이미 로그인이 되어 있습니다')");
		 script.println("location.href='main.jsp"); //메인 페이지로 돌려보냄
		 script.println("</script>");
	}
		if(user.getUserID() == null || user.getUserPassword() == null || user.getUserGender() == null  ||
           user.getUserName() == null || user.getUserEmail() == null)
		{
		 PrintWriter script = response.getWriter();
		 script.println("<script>");
		 script.println("alert('입력이 안 된 사항이 있습니다.')");
		 script.println("history.back()"); 
		 script.println("</script>");
		}
		else
		{
			
		UserDAO userDAO = new UserDAO();
		int result = userDAO.join(user); //각각의 값을 입력받은 user라는 인스턴스가 join 함수를 수행하도록 매개변수가 됨
		
		//DB를 생성할때 ID는 PRIMARY값, 동일한 아이디 생성불가
		 if(result == -1)
		 {
			 PrintWriter script = response.getWriter();
			 script.println("<script>");
			 script.println("alert('이미 존재하는 아이디 입니다.')");
			 script.println("history.back()"); //이전 페이지로 돌려보냄
			 script.println("</script>"); 
		 }
		
		 
		 else 		//회원가입 성공
		 {
			 session.setAttribute("userID", user.getUserID());	//세션부여
			 PrintWriter script = response.getWriter();
			 script.println("<script>");
			 script.println("location.href = 'main.jsp'"); //회원가입이 된경우 => main.jsp 페이지로 이동
			 script.println("</script>");
		 }
		}
	%>
</body>
</html>