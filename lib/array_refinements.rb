module ArrayRefinements
  refine Array do
    def skip(number_of_elements)
      Array(self[number_of_elements..])
    end
  end
end
