# Scripts WooCommerce

## Upload Mock Products

Acest script șterge toate produsele și categoriile existente din WooCommerce și le înlocuiește cu produsele mock din aplicație.

### Ce face scriptul:

1. **Șterge toate produsele existente** din magazin
2. **Șterge toate categoriile existente** (păstrează doar categoria default "Uncategorized")
3. **Creează categoriile noi:**
   - Îmbrăcăminte
   - Cărți
   - Suveniruri
   - Decorațiuni
   - Bijuterii
   - Instrumente
   - Artă
   - Papetărie
   - Cadouri

4. **Încarcă produsele mock** (13 produse în total)

### Cum se rulează:

```bash
# Din directorul root al proiectului
dart run scripts/upload_mock_products.dart
```

### Cerințe:

- Fișierul `.env` trebuie să conțină:
  - `WOOCOMMERCE_STORE_URL`
  - `WOOCOMMERCE_CONSUMER_KEY`
  - `WOOCOMMERCE_CONSUMER_SECRET`

### Produse incluse:

**Îmbrăcăminte (2)**
- Tricou Logo R.L. 126 C.T. - 89.99 Lei
- Eșarfă Ceremonială Roșu-Auriu - 149.99 Lei (reduced from 179.99)

**Cărți (2)**
- Istoria Cavalerilor Templului - 79.99 Lei
- Simboluri și Ritualuri Medievale - 65.99 Lei

**Suveniruri (2)**
- Breloc Cruce Templierii - 29.99 Lei (reduced from 39.99)
- Magnet Frigider Logo R.L. 126 - 19.99 Lei

**Decorațiuni (1)**
- Placă Decorativă Stemă - 199.99 Lei

**Bijuterii (2)**
- Inel Crucea Templiară - 249.99 Lei (reduced from 299.99)
- Colier Pandantiv Scut - 189.99 Lei

**Instrumente (1)**
- Spadă Decorativă Replica - 449.99 Lei

**Artă (1)**
- Tablou Canvas Cruciada - 329.99 Lei (reduced from 399.99)

**Papetărie (1)**
- Agendă Elegantă Logo Emblem - 59.99 Lei

**Cadouri (1)**
- Set Cadou Premium - Cavaleri - 299.99 Lei (reduced from 380.00)

### ⚠️ ATENȚIE

Acest script **ȘTERGE PERMANENT** toate produsele și categoriile existente din magazin!

Folosește-l doar pentru:
- Medii de development/staging
- Resetarea magazinului la starea inițială
- Testare

**NU RULA în producție fără un backup complet!**
