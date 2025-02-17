import React, { useState } from "react";

export function VoteAndIssue({ vote, issueTokens, isAdmin, balance, users }) {
  const [codinome, setCodinome] = useState("");
  const [amount, setAmount] = useState("");

  const handleVote = (event) => {
    event.preventDefault();
    if (codinome && amount) {
      vote(codinome, amount);
    }
  };

  const handleIssueTokens = (event) => {
    event.preventDefault();
    if (codinome && amount) {
      issueTokens(codinome, amount);
    }
  };

  // Se for admin e não houver saldo, só deve aparecer a opção para emitir tokens
  if (isAdmin)  {
    return (
      <div>
        <h4>Emitir Tokens</h4>
        <form>
          <div className="form-group">
            <label>Codinome</label>
            <select
              className="form-control"
              name="codinome"
              value={codinome}
              onChange={(e) => setCodinome(e.target.value)}
              required
            >
              <option value="">Selecione um codinome</option>
              {users.map((user, index) => (
                <option key={index} value={user}>
                  {user}
                </option>
              ))}
            </select>
          </div>
          <div className="form-group">
            <label>Quantidade de Turings</label>
            <input
              className="form-control"
              type="float"
              step="1"
              name="amount"
              placeholder="0.1"
              value={amount}
              onChange={(e) => setAmount(e.target.value)}
              required
            />
          </div>
          <div className="form-group d-flex mt-3">
            <button className="btn btn-success" onClick={handleIssueTokens}>
              Emitir Tokens
            </button>
          </div>
        </form>
      </div>
    );
  }

  // Se não for admin e tiver saldo, exibe a opção de votar
  if (!isAdmin && balance.gt(0)) {
    return (
      <div>
        <h4>Votar</h4>
        <form>
          <div className="form-group">
            <label>Codinome</label>
            <select
              className="form-control"
              name="codinome"
              value={codinome}
              onChange={(e) => setCodinome(e.target.value)}
              required
            >
              <option value="">Selecione um codinome</option>
              {users.map((user, index) => (
                <option key={index} value={user}>
                  {user}
                </option>
              ))}
            </select>
          </div>
          <div className="form-group">
            <label>Quantidade de Turings</label>
            <input
              className="form-control"
              type="float"
              step="1"
              name="amount"
              placeholder="0.1"
              value={amount}
              onChange={(e) => setAmount(e.target.value)}
              required
            />
          </div>
          <div className="form-group d-flex mt-3">
            <button className="btn btn-primary" onClick={handleVote}>
              Votar
            </button>
          </div>
        </form>
      </div>
    );
  }

  // Se não for admin e não houver saldo, não exibe nada
  return null;
}