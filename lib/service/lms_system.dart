import '../model/course.dart';
import '../model/student.dart';
import '../model/course_result.dart';

class LmsSystem {
  final List<Student> students = [];
  final List<Course> courses = [];
  final List<CourseResult> results = [];

  // Add a student
  void addStudent({
    required String studentID,
    required String studentName,
  }) {
    Student? student = _findStudentOrNull(studentID);

    if (student != null) {
      throw Exception('Student $studentID already exists');
    }

    students.add(
      Student(id: studentID, name: studentName),
    );
  }

  // Find a student by ID
  Student? _findStudentOrNull(String studentID) {
    for (Student student in students) {
      if (student.id == studentID) {
        return student;
      }
    }

    return null;
  }

  // Remove a student and all their related data
  void removeStudent({required String studentID}) {
    Student? student = _findStudentOrNull(studentID);

    if (student == null) {
      throw Exception('Student $studentID not found');
    }

    // Remove the student from every course
    for (Course course in courses) {
      course.studentIds.remove(studentID);
    }

    // Remove all results belonging to this student
    results.removeWhere(
      (result) => result.studentID == studentID,
    );

    // Remove the student
    students.removeWhere(
      (student) => student.id == studentID,
    );
  }

  // Add a course
  void addCourse({
    required String courseId,
    required String courseName,
  }) {
    Course? course = _findCourseOrNull(courseId);

    if (course != null) {
      throw Exception('Course $courseId already exists');
    }

    courses.add(
      Course(id: courseId, name: courseName),
    );
  }

  // Find a course by ID
  Course? _findCourseOrNull(String courseId) {
    for (Course course in courses) {
      if (course.id == courseId) {
        return course;
      }
    }

    return null;
  }

  // Remove a course and its results
  void removeCourse({required String courseID}) {
    Course? course = _findCourseOrNull(courseID);

    if (course == null) {
      throw Exception('Course $courseID not found');
    }

    // Remove all results belonging to this course
    results.removeWhere(
      (result) => result.courseId == courseID,
    );

    // Remove the course
    courses.removeWhere(
      (course) => course.id == courseID,
    );
  }

  // Enroll a student in a course
  void enrollStudent(String studentID, String courseId) {
    // Check that the student exists
    Student? student = _findStudentOrNull(studentID);

    if (student == null) {
      throw Exception('Student $studentID not found');
    }

    // Check that the course exists
    Course? course = _findCourseOrNull(courseId);

    if (course == null) {
      throw Exception('Course $courseId not found');
    }

    // Check that the student is not already enrolled
    if (course.studentIds.contains(studentID)) {
      throw Exception(
        'Student $studentID is already enrolled in course $courseId',
      );
    }

    // Add the enrollment
    course.studentIds.add(studentID);
  }

  // Remove a student from a course
  void discardStudentFromCourse(
    String studentID,
    String courseId,
  ) {
    // Check that the student exists
    Student? student = _findStudentOrNull(studentID);

    if (student == null) {
      throw Exception('Student $studentID not found');
    }

    // Check that the course exists
    Course? course = _findCourseOrNull(courseId);

    if (course == null) {
      throw Exception('Course $courseId not found');
    }

    // Check that the student is enrolled
    if (!course.studentIds.contains(studentID)) {
      throw Exception(
        'Student $studentID is not enrolled in course $courseId',
      );
    }

    // Remove the enrollment
    course.studentIds.remove(studentID);

    // Remove this student's result for this course
    results.removeWhere(
      (result) =>
          result.studentID == studentID &&
          result.courseId == courseId,
    );
  }
}