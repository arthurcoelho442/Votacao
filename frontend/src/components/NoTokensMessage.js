import React from "react";

export function NoTokensMessage({ selectedAddress }) {
  return (
    <>
      <p>Você não tem faucet para fazer transação</p>
      <p>
        Para obter mais, solicite aos administradores ou execute o comando abaixo:
        <br />
        <br />
        <code>npx hardhat --network localhost faucet {selectedAddress}</code>
      </p>
    </>
  );
}