
import reactLogo from './assets/react.svg'
import viteLogo from '/vite.svg'
import './App.css'

import { useEffect, useState } from "react";

function App() {
  const [data, setData] = useState(null);

  useEffect(() => {
    fetch("/api/data")
      .then((res) => res.json())
      .then((json) => setData(json));
  }, []);

  return (
    <div className="min-h-screen flex items-center justify-center bg-gray-100 text-center">
      <div>
        <h1 className="text-3xl font-bold mb-4">OnFinance AI Frontend</h1>
        <p className="text-lg text-gray-700">
          {data ? data.message : "Loading..."}
        </p>
      </div>
    </div>
  );
}

export default App;