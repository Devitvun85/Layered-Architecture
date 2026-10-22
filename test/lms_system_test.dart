
import 'package:test/test.dart';
import '../lib/service/lms_system.dart';

void main() {
  test('creates and removes a student', () {
    final lms = LmsSystem();

    lms.addStudent(studentId: 'S1', studentName: 'ronan');

    expect(lms.students.length, 1);
    expect(lms.students.first.name, 'ronan');

    lms.removeStudent(studentId: 'S1');

    expect(lms.students.length, 0);
  });

  test('creates and removes a course', () {
    final lms = LmsSystem();

    lms.addCourse(courseId: 'C1', courseName: 'Dart');

    expect(lms.courses.length, 1);
    expect(lms.courses.first.name, 'Dart');

    lms.removeCourse(courseID: 'C1');

    expect(lms.courses.length, 0);
  });

  test('throws exception when adding duplicate student', () {
    final lms = LmsSystem();

    lms.addStudent(studentId: 'S1', studentName: 'ronan');

    expect(
      () => lms.addStudent(
        studentId: 'S1',
        studentName: 'dara',
      ),
      throwsException,
    );
  });
}
