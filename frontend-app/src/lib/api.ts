export interface JsonApiSingle<T> {
  data: T;
}

export interface JsonApiList<T> {
  data: T[];
  meta?: Record<string, unknown>;
}

export interface JsonApiBase<
  TAttributes = Record<string, unknown>,
  IRelationships = Record<string, unknown>
> {
  id?: number;
  type: string;
  attributes: TAttributes;
  relationships: IRelationships;
}

export interface UserAttributes {
  email: string;
  password?: string;
}

export type JsonApiUser = JsonApiBase<UserAttributes>;

export interface ProductAttributes {
  name: string;
  price: number;
  description?: string;
}

export type JsonApiProduct = JsonApiBase<ProductAttributes>;

interface OrderItemAttributes {
  name: string;
  price: number;
  quantity: number;
}

interface OrderItemRelationships {
  product: {data: JsonApiProduct};
}

export type JsonApiOrderItem = JsonApiBase<
  OrderItemAttributes,
  OrderItemRelationships
>;

export interface IFilter {
  [key: string]: string | number | boolean | undefined;
}

// const res: JsonApiSingle<JsonApiUser> = await fetchUser();

export async function fetchProducts(filter: IFilter) {
  const params = new URLSearchParams(
    filter as Record<string, string>
  ).toString();

  const token = localStorage.getItem("token");
  try {
    const res = await fetch(
      `${process.env.NEXT_PUBLIC_API_URL}/api/v1/products?${params}`,
      {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      }
    );

    if (!res.ok) {
      throw new Error(`Error ${res.status}`);
    }

    return await res.json();
  } catch (err) {
    console.error("Failed to fetch products:", err);
    throw err;
  }
}

export async function fetchUser(id: number) {
  const token = localStorage.getItem("token");

  try {
    const res = await fetch(
      `${process.env.NEXT_PUBLIC_API_URL}/api/v1/users/${id}`,
      {
        method: "GET",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${token}`,
        },
      }
    );

    if (!res.ok) {
      throw new Error(`Error ${res.status}`);
    }
    const json: JsonApiSingle<JsonApiUser> = await res.json();
    return json.data as JsonApiUser;
  } catch (err) {
    console.error("Failed to fetch user::", err);
    throw err;
  }
}

export async function createUser(payload: JsonApiSingle<JsonApiUser>) {
  const token = localStorage.getItem("token");

  try {
    const res = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/v1/users`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`,
      },
      body: JSON.stringify(payload),
    });

    if (!res.ok) {
      const data = await res.json();
      const error = data.errors[0];
      throw new Error(error.title);
    }

    return await res.json();
  } catch (err) {
    console.error("Failed to create user:", err);
    throw err;
  }
}
