import 'package:test/test.dart';

import '../lib/service/lms_system.dart';
import '../lib/model/course_result.dart';

void main() {
  test('creates and removes a student', () {
    final lms = LmsSystem();

    lms.addStudent(
      studentID: 'S1',
      studentName: 'ronan',
    );

    expect(lms.students.length, 1);
    expect(lms.students.first.name, 'ronan');

    lms.removeStudent(studentID: 'S1');

    expect(lms.students.length, 0);
  });

  test('creates and removes a course', () {
    final lms = LmsSystem();

    lms.addCourse(
      courseId: 'C1',
      courseName: 'Dart',
    );

    expect(lms.courses.length, 1);
    expect(lms.courses.first.name, 'Dart');

    lms.removeCourse(courseID: 'C1');

    expect(lms.courses.length, 0);
  });

  test('throws exception when adding duplicate student', () {
    final lms = LmsSystem();

    lms.addStudent(
      studentID: 'S1',
      studentName: 'ronan',
    );

    expect(
      () => lms.addStudent(
        studentID: 'S1',
        studentName: 'dara',
      ),
      throwsException,
    );
  });

  test('enrolls a student in a course', () {
    final lms = LmsSystem();

    lms.addStudent(
      studentID: 'S1',
      studentName: 'Devit',
    );

    lms.addCourse(
      courseId: 'C1',
      courseName: 'Dart',
    );

    lms.enrollStudent('S1', 'C1');

    expect(
      lms.courses.first.studentIds,
      contains('S1'),
    );
  });

  test('rejects enrollment if student does not exist', () {
    final lms = LmsSystem();

    lms.addCourse(
      courseId: 'C1',
      courseName: 'Dart',
    );

    expect(
      () => lms.enrollStudent('S1', 'C1'),
      throwsException,
    );
  });

  test('rejects enrollment if course does not exist', () {
    final lms = LmsSystem();

    lms.addStudent(
      studentID: 'S1',
      studentName: 'Devit',
    );

    expect(
      () => lms.enrollStudent('S1', 'C1'),
      throwsException,
    );
  });

  test('rejects duplicate enrollment', () {
    final lms = LmsSystem();

    lms.addStudent(
      studentID: 'S1',
      studentName: 'Devit',
    );

    lms.addCourse(
      courseId: 'C1',
      courseName: 'Dart',
    );

    lms.enrollStudent('S1', 'C1');

    expect(
      () => lms.enrollStudent('S1', 'C1'),
      throwsException,
    );

    expect(
      lms.courses.first.studentIds.length,
      1,
    );
  });

  test('removes an existing enrollment', () {
    final lms = LmsSystem();

    lms.addStudent(
      studentID: 'S1',
      studentName: 'Ronan',
    );

    lms.addCourse(
      courseId: 'C1',
      courseName: 'Dart',
    );

    lms.enrollStudent('S1', 'C1');
    lms.discardStudentFromCourse('S1', 'C1');

    expect(lms.courses.first.studentIds, isEmpty);
  });

  test('rejects removal of a nonexistent enrollment', () {
    final lms = LmsSystem();

    lms.addStudent(
      studentID: 'S1',
      studentName: 'Ronan',
    );

    lms.addCourse(
      courseId: 'C1',
      courseName: 'Dart',
    );

    expect(
      () => lms.discardStudentFromCourse('S1', 'C1'),
      throwsException,
    );
  });

  test('student and course still exist after enrollment removal', () {
    final lms = LmsSystem();

    lms.addStudent(
      studentID: 'S1',
      studentName: 'Ronan',
    );

    lms.addCourse(
      courseId: 'C1',
      courseName: 'Dart',
    );

    lms.enrollStudent('S1', 'C1');
    lms.discardStudentFromCourse('S1', 'C1');

    expect(
      lms.students.any((s) => s.id == 'S1'),
      isTrue,
    );

    expect(
      lms.courses.any((c) => c.id == 'C1'),
      isTrue,
    );

    expect(lms.courses.first.studentIds, isEmpty);
  });

  test('removes the result associated with the enrollment', () {
    final lms = LmsSystem();

    lms.addStudent(
      studentID: 'S1',
      studentName: 'Ronan',
    );

    lms.addCourse(
      courseId: 'C1',
      courseName: 'Dart',
    );

    lms.addCourse(
      courseId: 'C2',
      courseName: 'Flutter',
    );

    lms.enrollStudent('S1', 'C1');
    lms.enrollStudent('S1', 'C2');

    lms.results.add(
      CourseResult(
        id: 1,
        studentID: 'S1',
        courseId: 'C1',
        score: 85,
      ),
    );

    lms.results.add(
      CourseResult(
        id: 2,
        studentID: 'S1',
        courseId: 'C2',
        score: 90,
      ),
    );

    lms.discardStudentFromCourse('S1', 'C1');

    // Result for C1 should be removed
    expect(
      lms.results.any(
        (r) => r.studentID == 'S1' && r.courseId == 'C1',
      ),
      isFalse,
    );

    // Result for C2 should remain
    expect(
      lms.results.any(
        (r) => r.studentID == 'S1' && r.courseId == 'C2',
      ),
      isTrue,
    );
  });

  test('removing a student clears all their enrollments and results', () {
    final lms = LmsSystem();

    lms.addStudent(
      studentID: 'S1',
      studentName: 'Ronan',
    );

    lms.addCourse(
      courseId: 'C1',
      courseName: 'Dart',
    );

    lms.addCourse(
      courseId: 'C2',
      courseName: 'Flutter',
    );

    lms.enrollStudent('S1', 'C1');
    lms.enrollStudent('S1', 'C2');

    lms.results.add(
      CourseResult(
        id: 1,
        studentID: 'S1',
        courseId: 'C1',
        score: 85,
      ),
    );

    lms.results.add(
      CourseResult(
        id: 2,
        studentID: 'S1',
        courseId: 'C2',
        score: 90,
      ),
    );

    lms.removeStudent(studentID: 'S1');

    // Student should no longer exist
    expect(
      lms.students.any((s) => s.id == 'S1'),
      isFalse,
    );

    // No course should contain this student
    expect(
      lms.courses.every((c) => !c.studentIds.contains('S1')),
      isTrue,
    );

    // No results should belong to this student
    expect(
      lms.results.any((r) => r.studentID == 'S1'),
      isFalse,
    );
  });
}