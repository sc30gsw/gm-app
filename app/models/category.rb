class Category < ActiveHash::Base
  self.data = [
    {id: 1, name: "--"},
    {id: 2, name: "縄文"},
    {id: 3, name: "弥生"},
    {id: 4, name: "古墳"},
    {id: 5, name: "飛鳥"},
    {id: 6, name: "奈良"},
    {id: 7, name: "平安"},
    {id: 8, name: "鎌倉"},
    {id: 9, name: "室町"},
    {id: 10, name: "安土桃山"},
    {id: 11, name: "江戸"},
    {id: 12, name: "明治"},
    {id: 13, name: "幕末"},
    {id: 14, name: "大正"},
    {id: 15, name: "昭和"},
    {id: 16, name: "ヨーロッパ"},
    {id: 17, name: "北アメリカ"},
    {id: 18, name: "南アメリカ"},
    {id: 19, name: "中国"},
    {id: 20, name: "東南アジア"},
    {id: 21, name: "オセアニア"},
    {id: 22, name: "アフリカ"},
    {id: 23, name: "現代"}
  ]

  include ActiveHash::Associations
  has_many :mans
end
