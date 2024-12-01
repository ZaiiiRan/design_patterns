class Data_storage_strategy
    # read from file
    def read(file_path)
        raise NotImplementedError, 'Not implemented'
    end

    # write to file
    def write(file_path, students)
        raise NotImplementedError, 'Not implemented'
    end
end