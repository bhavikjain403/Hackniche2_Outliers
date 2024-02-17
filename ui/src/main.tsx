import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App.tsx';
import './index.css';
import { BrowserRouter } from 'react-router-dom';
import { DayPickerProvider } from 'react-day-picker';
import { Toaster } from './components/ui/sonner.tsx';

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <BrowserRouter>
      <DayPickerProvider initialProps={{}}>
        <Toaster />
        <App />
      </DayPickerProvider>
    </BrowserRouter>
  </React.StrictMode>
);
