# テーブル設計

## users テーブル

| Column   | Type   | Options     |
| -------- | ------ | ----------- |
| nickname | string | null: false |
| email    |        |             |
| password |        |             |

### Associations

- has_one :intro
- has_many :sns_credentials
- has_many :mans
- has_many :comments
- has_many :likes, dependent: :destroy
- has_many :liked_mans, through: :likes, source: :man

## sns_credentials テーブル

| Column   | Type       | Options           |
| -------- | ---------- | ----------------- |
| provider | string     |                   |
| uid      | string     |                   |
| user     | references | foreign_key: true |


### Associations

- belongs_to :user, optional: true

## intros テーブル

| Column  | Type       | Options           |
| ------- | ---------- | ----------------- |
| profile | text       |                   |
| website | string     |                   |
| user    | references | foreign_key: true |

### Associations

- belongs_to :user

## mans テーブル

| Column      | Type       | Options           |
| ----------- | ---------- | ----------------- |
| name        | string     | null: false       |
| content     | text       |                   |
| category_id | integer    | null: false       |
| address     | string     | null: false       |
| latitude    | float      | null: false       |
| longitude   | float      | null: false       |
| user        | references | foreign_key: true |

### Associations

- has_many :comments
- has_many :likes, dependent: :destroy
- has_many :liked_users, through: :likes, source: :user
- belongs_to :user
- belongs_to :category


## comments テーブル

| Column  | Type       | Options           |
| ------- | ---------- | ----------------- |
| text    | text       | null: false       |
| user    | references | foreign_key: true |
| man     | references | foreign_key: true |

### Associations

- belongs_to :user
- belongs_to :man

## likes テーブル

| Column | Type       | Options           |
| ------ | ---------- | ----------------- |
| user   | references | foreign_key: true |
| man    | references | foreign_key: true |

### Associations

- belongs_to :user
- belongs_to :man