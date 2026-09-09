export interface AdminUser {
  id: string
  email: string
  name: string
  teamId: string
  teamName: string
  notificationDaysBefore: number
  banned: boolean
  createdAt: string
}

export interface AdminTeam {
  id: string
  name: string
  inviteCode: string
  memberCount: number
  createdAt: string
}

export interface Category {
  id: string
  code: string
  nameIt: string
  nameEn: string
  nameEs: string
  nameFr: string
}

export interface Product {
  id: string
  barcode: string
  name: string
  brand: string | null
  categoryId: string | null
  imageUrl: string | null
  daysAfterOpening: number | null
  source: string
}

export interface AdminEmail {
  id: string
  email: string
  createdAt: string
}

export interface Stats {
  userCount: number
  teamCount: number
  productCount: number
  inventoryItemCount: number
}
