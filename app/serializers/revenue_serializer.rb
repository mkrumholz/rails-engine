class RevenueSerializer
  def self.format_json(revenue)
    { 
      data:
      {
        id: nil,
        attributes: {
          revenue: revenue
        }
      }
    }
  end
end
