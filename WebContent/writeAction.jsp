<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="bbs.BbsDAO" %> 
<%@ page import="java.io.PrintWriter" %> 
<% request.setCharacterEncoding("UTF-8"); %> <!-- 모든 데이터를 UTF-8로 받음 -->
<jsp:useBean id="bbs" class="bbs.Bbs" scope="page" /> 
<jsp:setProperty name="bbs" property="bbsTitle" />
<jsp:setProperty name="bbs" property="bbsContent" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판</title>
</head>
<body>

<!-- 로그인이 되어있는 경우에만 글쓰기 허용 -->
	<%
		String userID=null;
		if(session.getAttribute("userID") != null){	//세션이 존재할 때
			userID = (String) session.getAttribute("userID");		
		}
		if(userID == null){		//로그인이 안된경우
			PrintWriter script = response.getWriter();
			 script.println("<script>");
			 script.println("alert('로그인이 필요합니다.')");
			 script.println("location.href='login.jsp'"); //메인 페이지로 돌려보냄
			 script.println("</script>");
		}else{
				if(bbs.getBbsTitle() == null || bbs.getBbsContent() == null)		//제목, 내용 입력이 되었는지 확인
				{
				 PrintWriter script = response.getWriter();
				 script.println("<script>");
				 script.println("alert('입력이 안 된 사항이 있습니다.')");
				 script.println("history.back()"); 
				 script.println("</script>");
				}
				else
				{
					BbsDAO bbsDAO = new BbsDAO();
					int result = bbsDAO.write(bbs.getBbsTitle(), userID, bbs.getBbsContent()); 
					 if(result == -1)
					 {
						 PrintWriter script = response.getWriter();
						 script.println("<script>");
						 script.println("alert('글쓰기에 실패 하였습니다.')");
						 script.println("history.back()"); //이전 페이지로 돌려보냄
						 script.println("</script>"); 
					 }
	
					 else{		// 글쓰기 성공
						 PrintWriter script = response.getWriter();
						 script.println("<script>");
						 script.println("location.href = 'bbs.jsp'"); //완료후 bbs페이지로
						 script.println("</script>");
					 }
				}
			}
		
	%>
</body>
</html>