import React from "react";
import ReactDOM from "react-dom/client";
import App from "./App.tsx";
import "./index.css";
import { BrowserRouter } from "react-router-dom";
import { DayPickerProvider } from "react-day-picker";

ReactDOM.createRoot(document.getElementById("root")!).render(
  <React.StrictMode>
    <BrowserRouter>
      <DayPickerProvider initialProps={{}}>
        <App />
      </DayPickerProvider>
    </BrowserRouter>
  </React.StrictMode>
);
