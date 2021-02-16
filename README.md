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
- has_many :relationships, dependent: :destroy
- has_many :followings, through: :relationships, source: :follow
- has_many :reverse_of_relationsihps, class_name: 'Relationship', foreign_key: 'follow_id'
- has_many :followers, through: :reverse_of_relationsihps, source: :user
- has_many :active_notifications, class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy
- has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy

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

## mens テーブル

| Column      | Type       | Options           |
| ----------- | ---------- | ----------------- |
| name        | string     | null: false       |
| content     | text       |                   |
| category_id | integer    | null: false       |
| tagbody     | string     |                   |
| address     | string     | null: false       |
| latitude    | float      | null: false       |
| longitude   | float      | null: false       |
| user        | references | foreign_key: true |

### Associations

- has_many :comments
- has_many :likes, dependent: :destroy
- has_many :liked_users, through: :likes, source: :user
- has_many :notifications, dependent: :destroy
- has_many :man_tags
- has_many :tags, through: :man_tags
- belongs_to :user
- belongs_to :category


## comments テーブル

| Column  | Type       | Options           |
| ------- | ---------- | ----------------- |
| text    | text       | null: false       |
| user    | references | foreign_key: true |
| man     | references | foreign_key: true |

### Associations

- has_many :notifications, dependent: :destroy
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

## relationships テーブル

| Column               | Type       | Options                       |
| -------------------- | ---------- | ----------------------------- |
| user                 | references | foreign_key: true             |
| follow               | references | foreign_key: to_table: :users |
| [user_id, follow_id] | index      | unique: true                  |

### Associations

- belongs_to :user
- belongs_to :follow, class_name: 'User'

## notifications テーブル

| Column     | Type    | Options                     |
| ---------- | ------- | --------------------------- |
| visitor_id | integer | null: false                 |
| visited_id | integer | null: false                 |
| man_id     | integer |                             |
| comment_id | integer |                             |
| action     | string  | default: '', null: false    |
| checked    | boolean | default: false, null: false |

### Associations

- belongs_to :man, optional: true
- belongs_to :comment, optional: true
- belongs_to :visitor, class_name: 'User', foreign_key: 'visitor_id', optional: true

## tags テーブル

| Column | Type   | Options      |
| ------ | ------ | ------------ |
| name   | string | unique: true |

### Associations

- has_many :man_tags
- has_many :mans, through: :man_tags

## man_tags テーブル

| Column | Type       | Options           |
| ------ | ---------- | ----------------- |
| man    | references | foreign_key: true |
| tag    | references | foreign_key: true |

### Associations

- belongs_to :man
- belongs_to :tag