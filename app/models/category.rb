class Category < ActiveHash::Base
  self.data = [
    {id: 1, name: "--"},
    {id: 2, name: "縄文時代"},
    {id: 3, name: "弥生時代"},
    {id: 4, name: "古墳時代"},
    {id: 5, name: "飛鳥時代"},
    {id: 6, name: "奈良時代"},
    {id: 7, name: "平安時代"},
    {id: 8, name: "鎌倉時代"},
    {id: 9, name: "室町時代"},
    {id: 10, name: "安土桃山時代"},
    {id: 11, name: "江戸時代"},
    {id: 12, name: "明治時代"},
    {id: 13, name: "大正時代"},
    {id: 14, name: "昭和時代"},
    {id: 15, name: "ヨーロッパ"},
    {id: 16, name: "北アメリカ"},
    {id: 17, name: "南アメリカ"},
    {id: 18, name: "中国"},
    {id: 19, name: "東南アジア"},
    {id: 20, name: "オセアニア"},
    {id: 21, name: "アフリカ"},
    {id: 22, name: "現代"}
  ]

  include ActiveHash::Associations
  has_many :mans
end
