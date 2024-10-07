class Processing
    def self.is_global_maximum(arr, index)
        return arr[index] == arr.max
    end

    def self.is_local_minimum(arr, index)
        if index == 0 then
            return arr[index] <= arr[index + 1]
        elsif index == arr.length - 1
            return arr[index] <= arr[index - 1]
        else
            return arr[index] <= arr[index - 1] && arr[index] <= arr[index + 1]
        end
    end

    def self.cyclic_shift(arr)
        arr.rotate
    end
end