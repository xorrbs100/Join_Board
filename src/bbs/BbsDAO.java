package bbs;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class BbsDAO {

	private Connection conn;
	private ResultSet rs;
	
	public BbsDAO() {	//DB접속
		try {
			String dbURL="jdbc:mysql://localhost:3306/bbs";
			String dbID="root";
			String dbPasswd="mysql";
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection(dbURL,dbID,dbPasswd);
		}catch(Exception e) {
			e.printStackTrace();
		}
	}
	public String getDate() {	//현재 서버의 시간 받아옴
		String SQL = "select NOW()";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getString(1);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return "DB오류";	//DB오류
	}
	public int getNext() {	//현재 서버의 시간 받아옴
		String SQL = "select bbsID from bbs order by bbsID desc";		//글의 ID로 정렬
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getInt(1) + 1;		//마지막 게시글번호+1
			}
			return 1; //첫번째 게시물인 경우
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1;	//DB오류
	}
	public int write(String bbsTitle, String userID, String bbsContent) {
		String SQL = "insert into bbs values(?, ?, ?, ?, ?, ?)";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext());	//bbsID
			pstmt.setString(2, bbsTitle);
			pstmt.setString(3, userID);
			pstmt.setString(4, getDate());
			pstmt.setString(5, bbsContent);
			pstmt.setInt(6, 1);
			return pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1;	//DB오류
	
	}
	public ArrayList<Bbs> getList(int pageNumber) {
		//bbsid가 특정조건보다 작을때, 10개까지 제한하여 나타냄
		String SQL = "select * from bbs where bbsID < ? AND bbsAvailable = 1 order by bbsID desc LIMIT 10";	
		ArrayList<Bbs> list = new ArrayList<Bbs>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			// 총5개의 글 나타냄
			pstmt.setInt(1, getNext()-(pageNumber - 1)*10);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				Bbs bbs = new Bbs();
				bbs.setBbsID(rs.getInt(1));
				bbs.setBbsTitle(rs.getString(2));
				bbs.setUserID(rs.getString(3));
				bbs.setBbsDate(rs.getString(4));
				bbs.setBbsContent(rs.getString(5));
				bbs.setBbsAvailable(rs.getInt(6));
				list.add(bbs);		
			}
			
		}catch(Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	public boolean nextPage(int pageNumber) {	//페이징 처리 함수
		//bbsid가 특정조건보다 작을때, 10개까지 제한하여 나타냄
				String SQL = "select * from bbs where bbsID < ? AND bbsAvailable = 1 order by bbsID desc LIMIT 10";	
				ArrayList<Bbs> list = new ArrayList<Bbs>();
				try {
					PreparedStatement pstmt = conn.prepareStatement(SQL);
					// 총5개의 글 나타냄
					pstmt.setInt(1, getNext()-(pageNumber - 1)*10);
					rs = pstmt.executeQuery();
					if(rs.next()) {
						return true;		
					}
					
				}catch(Exception e) {
					e.printStackTrace();
				}
				return false;
	}
	public Bbs getBbs(int bbsID) {
		String SQL = "select * from bbs where bbsID = ?";	
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, bbsID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				Bbs bbs = new Bbs();
				bbs.setBbsID(rs.getInt(1));
				bbs.setBbsTitle(rs.getString(2));
				bbs.setUserID(rs.getString(3));
				bbs.setBbsDate(rs.getString(4));
				bbs.setBbsContent(rs.getString(5));
				bbs.setBbsAvailable(rs.getInt(6));
				return bbs;
			}
			
		}catch(Exception e) {
			e.printStackTrace();
		}
		return null;		//해당글 존재하지 않을때 
	}
	public int update(int bbsID, String bbsTitle, String bbsContent) {
		String SQL = "update bbs set bbsTitle = ?, bbsContent = ? where bbsID= ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, bbsTitle);
			pstmt.setString(2, bbsContent);
			pstmt.setInt(3, bbsID);
			
			return pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1;	//DB오류
	}
	public int delete(int bbsID) {
		String SQL = "update bbs set bbsAvailable = 0 where bbsID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, bbsID);
			return pstmt.executeUpdate();
			
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1;	//DB오류
	}
}
