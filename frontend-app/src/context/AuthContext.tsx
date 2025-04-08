"use client";

import {fetchUser, JsonApiUser} from "@/lib/api";
import {jwtDecode} from "jwt-decode";
import {usePathname, useRouter} from "next/navigation";

import {createContext, useContext, useEffect, useState} from "react";

interface TokenPayload {
  id: number;
}

type AuthContextType = {
  isAuthenticated: boolean | undefined;
  currentUser: JsonApiUser | null;
  login: (email: string, password: string) => Promise<boolean>;
  logout: () => void;
};

const AuthContext = createContext<AuthContextType | null>(null);

export const AuthProvider = ({children}: {children: React.ReactNode}) => {
  const [isAuthenticated, setIsAuthenticated] = useState<boolean | undefined>(
    undefined
  );
  const [currentUser, setCurrentUser] = useState<JsonApiUser | null>(null);
  const pathname = usePathname();
  const router = useRouter();

  useEffect(() => {
    const token = localStorage.getItem("token");
    setIsAuthenticated(!!token);
  }, []);

  useEffect(() => {
    if (isAuthenticated === undefined) {
      return;
    }
    if (isAuthenticated) {
      if (pathname === "/login" || pathname === "/signup") {
        router.push("/products");
      }
      const token = localStorage.getItem("token");
      if (token) initCurrentUser(token);
    } else {
      if (pathname !== "/login" && pathname !== "/signup") {
        router.push("/login");
      }
      setCurrentUser(null);
    }
  }, [isAuthenticated, pathname, router]);

  const initCurrentUser = async (token: string) => {
    const decoded: TokenPayload = jwtDecode(token);
    const user = await fetchUser(decoded.id);
    console.log(user);
    setCurrentUser(user);
  };

  const login = async (email: string, password: string) => {
    try {
      const res = await fetch(
        `${process.env.NEXT_PUBLIC_API_URL}/api/v1/token`,
        {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify({email, password}),
        }
      );

      if (!res.ok) return false;

      const data = await res.json();
      localStorage.setItem("token", data.token);
      setIsAuthenticated(true);
      return true;
    } catch (err) {
      console.error("Login error:", err);
      return false;
    }
  };

  const logout = () => {
    localStorage.removeItem("token");
    setIsAuthenticated(false);
  };

  return (
    <AuthContext.Provider value={{isAuthenticated, currentUser, login, logout}}>
      {children}
    </AuthContext.Provider>
  );
};

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (!context) throw new Error("useAuth must be used inside AuthProvider");
  return context;
};
