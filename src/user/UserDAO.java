package user;

import java.sql.*;

public class UserDAO {

	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	public UserDAO() {	//DB접속
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
	public int login(String userID, String userPassword) {	//로그인 처리함수
		String SQL = "SELECT userPassword From user WHERE userID =?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();	//쿼리문실행
			if(rs.next())
			{
				if(rs.getString(1).equals(userPassword))
				{
					return 1;	//로그인 성공
				}
				else
					return 0; //로그인 실패 (비밀번호 오류)
			}
			return -1;	// 아이디 없음
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -2; //DB오류
	}
	public int join(User user) {
		String SQL = "insert into user values(?, ?, ?, ?, ?)";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, user.getUserID());
			pstmt.setString(2, user.getUserPassword());
			pstmt.setString(3, user.getUserName());
			pstmt.setString(4, user.getUserGender());
			pstmt.setString(5, user.getUserEmail());
			return pstmt.executeUpdate();		//회원가입 성공시 0이상 반환
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1;		//DB오류
	}
}
