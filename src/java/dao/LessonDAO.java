package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Lesson;

public class LessonDAO {

    public List<Lesson> getLessonsByCourseId(int courseId) {
        List<Lesson> list = new ArrayList<>();
        String sql = "SELECT LessonID, CourseID, Title, VideoURL, Duration FROM Lesson WHERE CourseID = ? ORDER BY LessonID ASC";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapLesson(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Lesson getLessonById(int lessonId) {
        String sql = "SELECT LessonID, CourseID, Title, VideoURL, Duration FROM Lesson WHERE LessonID = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, lessonId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapLesson(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public int getMaxDurationByCourseId(int courseId) {
        String sql = "SELECT ISNULL(MAX(Duration), 0) AS MaxDuration FROM Lesson WHERE CourseID = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt("MaxDuration");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public boolean createLesson(Lesson lesson) {
        String sql = "INSERT INTO Lesson(CourseID, Title, VideoURL, Duration) VALUES (?, ?, ?, ?)";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, lesson.getCourseID());
            ps.setString(2, lesson.getTitle());
            ps.setString(3, lesson.getVideoURL());
            ps.setInt(4, lesson.getLessonOrder());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateLesson(Lesson lesson) {
        String sql = "UPDATE Lesson SET Title=?, VideoURL=?, Duration=? WHERE LessonID=?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, lesson.getTitle());
            ps.setString(2, lesson.getVideoURL());
            ps.setInt(3, lesson.getLessonOrder());
            ps.setInt(4, lesson.getLessonID());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteLesson(int lessonId) {
        String sql = "DELETE FROM Lesson WHERE LessonID = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, lessonId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private Lesson mapLesson(ResultSet rs) throws Exception {
        Lesson lesson = new Lesson();
        lesson.setLessonID(rs.getInt("LessonID"));
        lesson.setCourseID(rs.getInt("CourseID"));
        lesson.setTitle(rs.getString("Title"));
        lesson.setVideoURL(rs.getString("VideoURL"));
        lesson.setLessonOrder(rs.getObject("Duration") == null ? 0 : rs.getInt("Duration"));
        return lesson;
    }
}
