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

// test for  Enroll a student in a course
  test(' Enroll a student in a course', () {
    final lms = LmsSystem();

    lms.addStudent(studentId: 'S1', studentName: 'Devit');
    lms.addCourse(courseId: 'C1', courseName: 'Dart');

    lms.enrollStudent('S1', "C1");

    expect(lms.courses.first.studentIds, contains("S1"));
  });

  test('rejects enrollment if student does not exist', () {
    final lms = LmsSystem();
    lms.addCourse(courseId: 'C1', courseName: "dart");
    expect(
      () => lms.enrollStudent('S1', 'C1'),
      throwsException,
    );
  });
  test('rejects enrollment if course does not exist', () {
    final lms = LmsSystem();
  lms.addStudent(studentId: 'S1', studentName: 'Devit');
  expect(
    () => lms.enrollStudent('S1', 'C1'),
    throwsException,
  );
  });
  
  test('rejects duplicate enrollment', () {
    final lms = LmsSystem();

    lms.addStudent(studentId: 'S1', studentName: 'C1');
      lms.addCourse(courseId: 'C1', courseName: 'Dart');

  lms.enrollStudent('S1', 'C1');

  expect(
    () => lms.enrollStudent('S1', 'C1'),
    throwsException,
  );

  expect(lms.courses.first.studentIds.length, 1);
  });
}
