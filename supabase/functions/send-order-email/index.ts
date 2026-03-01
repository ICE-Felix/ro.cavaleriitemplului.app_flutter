import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const RESEND_API_KEY = Deno.env.get("RESEND_API_KEY")!;
const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!;
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;

serve(async (req) => {
  const { order_id } = await req.json();

  const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);

  // Get order with items
  const { data: order, error: orderError } = await supabase
    .from("shop_orders")
    .select("*, shop_order_items(*)")
    .eq("id", order_id)
    .single();

  if (orderError) {
    return new Response(JSON.stringify({ error: orderError.message }), {
      status: 400,
    });
  }

  // Get email config
  const { data: config } = await supabase
    .from("shop_config")
    .select("key, value")
    .in("key", ["order_email_to", "order_email_cc1", "order_email_cc2"]);

  const emailConfig: Record<string, string> = {};
  config?.forEach((row: { key: string; value: string }) => {
    emailConfig[row.key] = row.value;
  });

  const toEmail = emailConfig["order_email_to"];
  const ccEmails = [
    emailConfig["order_email_cc1"],
    emailConfig["order_email_cc2"],
  ].filter(Boolean);

  // Build HTML email
  const itemsHtml = order.shop_order_items
    .map(
      (item: any) =>
        `<tr>
          <td style="padding:8px;border:1px solid #ddd">${item.product_name}</td>
          <td style="padding:8px;border:1px solid #ddd;text-align:center">${item.quantity}</td>
          <td style="padding:8px;border:1px solid #ddd;text-align:right">${item.product_price.toFixed(2)} Lei</td>
          <td style="padding:8px;border:1px solid #ddd;text-align:right">${(item.product_price * item.quantity).toFixed(2)} Lei</td>
        </tr>`
    )
    .join("");

  const html = `
    <h2>Comanda noua de la ${order.user_name}</h2>
    <p><strong>Email:</strong> ${order.user_email}</p>
    <p><strong>Data:</strong> ${new Date(order.created_at).toLocaleString("ro-RO")}</p>
    ${order.note ? `<p><strong>Nota:</strong> ${order.note}</p>` : ""}
    <table style="border-collapse:collapse;width:100%">
      <thead>
        <tr style="background:#f5f5f5">
          <th style="padding:8px;border:1px solid #ddd;text-align:left">Produs</th>
          <th style="padding:8px;border:1px solid #ddd">Cantitate</th>
          <th style="padding:8px;border:1px solid #ddd;text-align:right">Pret</th>
          <th style="padding:8px;border:1px solid #ddd;text-align:right">Subtotal</th>
        </tr>
      </thead>
      <tbody>${itemsHtml}</tbody>
      <tfoot>
        <tr>
          <td colspan="3" style="padding:8px;border:1px solid #ddd;text-align:right"><strong>Total:</strong></td>
          <td style="padding:8px;border:1px solid #ddd;text-align:right"><strong>${order.total.toFixed(2)} Lei</strong></td>
        </tr>
      </tfoot>
    </table>
  `;

  // Send via Resend
  const res = await fetch("https://api.resend.com/emails", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      Authorization: `Bearer ${RESEND_API_KEY}`,
    },
    body: JSON.stringify({
      from: "Cavalerii Templului <rl126ct@530am.io>",
      to: [toEmail],
      cc: ccEmails,
      subject: `Comanda noua de la ${order.user_name}`,
      html: html,
    }),
  });

  const resendResult = await res.json();

  return new Response(JSON.stringify({ success: true, resend: resendResult }), {
    headers: { "Content-Type": "application/json" },
  });
});
