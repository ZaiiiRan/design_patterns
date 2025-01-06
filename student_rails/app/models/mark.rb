class Mark < ApplicationRecord
    belongs_to :student
    belongs_to :lab

    validates :grade, presence: true, inclusion: { in: [ "+", "++", "3", "4", "5" ] }
    validates :due_date, presence: true
    validates :comment, length: { maximum: 100 }
    validates :justification, length: { maximum: 1000 }

    validate :due_date_after_lab_date_of_issue
    validate :due_date_after_last_grade_date, on: :create

    before_save :mark_previous_final_grades_as_non_final

    private
    def due_date_after_lab_date_of_issue
        if lab.date_of_issue.present? && due_date < lab.date_of_issue
            errors.add(:due_date, "должна быть позже даты выдачи ЛР (#{lab.date_of_issue})")
        end
    end

    def due_date_after_last_grade_date
        last_grade = student.marks.where(lab: lab).order(due_date: :desc).first
        if last_grade&.due_date.present? && due_date <= last_grade.due_date
            errors.add(:due_date, "должна быть позже последней даты защиты (#{last_grade.due_date})")
        end
    end

    def mark_previous_final_grades_as_non_final
        if final?
            student.marks.where(lab: lab).update_all(final: false)
        end
    end
end
