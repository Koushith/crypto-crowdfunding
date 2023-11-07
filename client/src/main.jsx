import React from "react";
import { createRoot } from "react-dom/client";
import App from "./App";
import { BrowserRouter } from 'react-router-dom'
import { ChainId, ThirdwebProvider } from "@thirdweb-dev/react";
import { Goerli } from '@thirdweb-dev/chains'
import "./styles/globals.css";
import { StateContextProvider } from "./context";

// This is the chain your dApp will work on.
// Change this to the chain your app is built for.
// You can also import additional chains from `@thirdweb-dev/chains` and pass them directly.
const activeChain = "goerli";

const container = document.getElementById("root");
const root = createRoot(container);
root.render(
  <React.StrictMode>
    <ThirdwebProvider
       desiredChainId={ChainId.Goerli}
         activeChain="goerli" 
        clientId="15bb2287c2a538a792df40cf042cb03d"
    >
      <BrowserRouter>
        <StateContextProvider>
          <App />
        </StateContextProvider>

      </BrowserRouter>

    </ThirdwebProvider>
  </React.StrictMode>
);
