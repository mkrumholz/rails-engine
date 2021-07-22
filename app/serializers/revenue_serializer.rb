class RevenueSerializer
  def self.format_json(revenue)
    {
      data:
      {
        id: nil,
        type: 'revenue',
        attributes: {
          revenue: revenue
        }
      }
    }
  end
end
