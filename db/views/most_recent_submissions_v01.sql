WITH ranked_submissions AS (
       SELECT submissions.*,
              ROW_NUMBER() OVER (PARTITION BY submissions.course_programming_lab_id, submissions.author_type, submissions.author_id ORDER BY submissions.created_at DESC) rank
       FROM submissions
       ORDER BY submissions.course_programming_lab_id
)
SELECT id,
       id submission_id,
       created_at,
       updated_at,
       student_comment,
       instructor_comment,
       grade,
       course_programming_lab_id,
       author_type,
       author_id
FROM ranked_submissions
WHERE rank = 1
