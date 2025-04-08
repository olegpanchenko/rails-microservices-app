"use client";

import {useState} from "react";
import {
  createUser,
  JsonApiSingle,
  JsonApiUser,
  UserAttributes,
} from "@/lib/api";
import {useRouter} from "next/navigation";

export default function Login() {
  const [formData, setFormData] = useState<UserAttributes>({
    email: "",
    password: "",
  });
  const [errorMessage, setErrorMessage] = useState<string>("");
  const router = useRouter();

  // Handle form input changes
  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const {name, value} = e.target;
    setFormData((prevData) => ({
      ...prevData,
      [name]: value,
    }));
  };

  // Handle form submission
  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    // Simple form validation
    if (!formData.email || !formData.password) {
      setErrorMessage("Please fill in both fields.");
      return;
    }

    const payload = {
      data: {
        type: "users",
        attributes: formData,
      },
    } as JsonApiSingle<JsonApiUser>;
    try {
      const data = await createUser(payload);

      if (data) {
        router.push("/login");
      } else {
        setErrorMessage(data.message || "Sign Up in failed.");
      }
    } catch (error) {
      setErrorMessage((error as Error).message);
    }
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-gray-100">
      <div className="w-full max-w-md p-8 space-y-6 bg-white rounded-lg shadow-lg">
        <h2 className="text-2xl font-bold text-center">Sign Up</h2>

        {/* Error message */}
        {errorMessage && (
          <div className="text-red-500 text-center mb-4">{errorMessage}</div>
        )}

        <form onSubmit={handleSubmit} className="space-y-4">
          <div>
            <label
              htmlFor="email"
              className="block text-sm font-medium text-gray-700"
            >
              Email Address
            </label>
            <input
              type="email"
              id="email"
              name="email"
              value={formData.email}
              onChange={handleChange}
              className="mt-1 block w-full px-4 py-2 border border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500"
              placeholder="Email"
            />
          </div>

          <div>
            <label
              htmlFor="password"
              className="block text-sm font-medium text-gray-700"
            >
              Password
            </label>
            <input
              type="password"
              id="password"
              name="password"
              value={formData.password}
              onChange={handleChange}
              className="mt-1 block w-full px-4 py-2 border border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500"
              placeholder="Password"
            />
          </div>

          <div>
            <button
              type="submit"
              className="w-full py-2 px-4 bg-blue-500 text-white rounded-md hover:bg-blue-600 focus:outline-none"
            >
              Sign Up
            </button>
          </div>

          <div className="text-center text-sm">
            Do you have an account?{" "}
            <a href="/login" className="text-blue-500 hover:text-blue-700">
              Login
            </a>
          </div>
        </form>
      </div>
    </div>
  );
}
