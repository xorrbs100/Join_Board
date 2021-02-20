<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="bbs.BbsDAO" %> 
<%@ page import="bbs.Bbs" %> 
<%@ page import="java.io.PrintWriter" %> 
<% request.setCharacterEncoding("UTF-8"); %> <!-- 모든 데이터를 UTF-8로 받음 -->
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
		}
		//글 유효성 검사
		int bbsID = 0;
		if(request.getParameter("bbsID") != null){		//bbsID가 존재한다면
			bbsID = Integer.parseInt(request.getParameter("bbsID"));		//bbsID 변수화
		}
		if(bbsID == 0){		//bbsID가 존재하지 않을경우
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('유효하지 않은 글입니다.')");
			script.println("location.href='bbs.jsp'"); //bbs 페이지로 돌려보냄
			script.println("</script>");
		}
		Bbs bbs = new BbsDAO().getBbs(bbsID);	//글의 작성자가 맞는지 확인
		if(!userID.equals(bbs.getUserID())){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('권한이 없습니다.')");
			script.println("location.href='bbs.jsp'");
			script.println("</script>");
		}
		else{
		
			BbsDAO bbsDAO = new BbsDAO();
			int result = bbsDAO.delete(bbsID);
			 if(result == -1)
			 {
				 PrintWriter script = response.getWriter();
				 script.println("<script>");
				 script.println("alert('글삭제에 실패 하였습니다.')");
				 script.println("history.back()"); //이전 페이지로 돌려보냄
				 script.println("</script>"); 
			 }

			 else{		// 삭제 성공
				 PrintWriter script = response.getWriter();
				 script.println("<script>");
				 script.println("location.href = 'bbs.jsp'"); //완료후 bbs페이지로
				 script.println("</script>");
			 }
		}
	
		
	%>
</body>
</html>