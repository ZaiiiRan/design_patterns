class Students_list_interface
    def get_student_by_id(id)
        raise NotImplementedError
    end

    def get_k_n_student_short_list(k, n)
        raise NotImplementedError
    end

    def add_student(student)
        raise NotImplementedError
    end

    def replace_student(id, new_student)
        raise NotImplementedError
    end

    def delete_student(id)
        raise NotImplementedError
    end

    def get_student_short_count
        raise NotImplementedError
    end

    protected
    attr_accessor :students_list
end