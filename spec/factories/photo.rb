FactoryGirl.define do
  factory :photo do
    basket
    image <<-B64.gsub(/\s+/, '')
      data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAABHN
      CSVQICAgIfAhkiAAAAAlwSFlzAAAN1wAADdcBQiibeAAAABl0RVh0U29mdHdhcmUAd3d3Lmlu
      a3NjYXBlLm9yZ5vuPBoAAAANSURBVAiZY/j//z8DAAj8Av6Fzas0AAAAAElFTkSuQmCC
    B64
  end
end
