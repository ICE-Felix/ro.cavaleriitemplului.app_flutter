import { serve } from "https://deno.land/std@0.168.0/http/server.ts";

const RESEND_API_KEY = Deno.env.get("RESEND_API_KEY")!;

serve(async (req) => {
  const { name, email, subject, message, category } = await req.json();

  const categoryLabels: Record<string, string> = {
    general: "General",
    technical: "Probleme Tehnice",
    membership: "Membru",
    events: "Evenimente",
    other: "Altele",
  };

  const html = `
    <h2>Solicitare suport noua</h2>
    <table style="border-collapse:collapse;width:100%;max-width:600px">
      <tr>
        <td style="padding:10px;border:1px solid #ddd;background:#f5f5f5;font-weight:bold;width:140px">Nume</td>
        <td style="padding:10px;border:1px solid #ddd">${name}</td>
      </tr>
      <tr>
        <td style="padding:10px;border:1px solid #ddd;background:#f5f5f5;font-weight:bold">Email</td>
        <td style="padding:10px;border:1px solid #ddd"><a href="mailto:${email}">${email}</a></td>
      </tr>
      <tr>
        <td style="padding:10px;border:1px solid #ddd;background:#f5f5f5;font-weight:bold">Categorie</td>
        <td style="padding:10px;border:1px solid #ddd">${categoryLabels[category] || category}</td>
      </tr>
      <tr>
        <td style="padding:10px;border:1px solid #ddd;background:#f5f5f5;font-weight:bold">Subiect</td>
        <td style="padding:10px;border:1px solid #ddd">${subject}</td>
      </tr>
      <tr>
        <td style="padding:10px;border:1px solid #ddd;background:#f5f5f5;font-weight:bold;vertical-align:top">Mesaj</td>
        <td style="padding:10px;border:1px solid #ddd;white-space:pre-wrap">${message}</td>
      </tr>
    </table>
  `;

  const res = await fetch("https://api.resend.com/emails", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      Authorization: `Bearer ${RESEND_API_KEY}`,
    },
    body: JSON.stringify({
      from: "Cavalerii Templului <rl126ct@530am.io>",
      to: ["rl126ct@530am.io"],
      reply_to: email,
      subject: `[Suport] ${subject}`,
      html: html,
    }),
  });

  const resendResult = await res.json();

  return new Response(
    JSON.stringify({ success: res.ok, resend: resendResult }),
    {
      status: res.ok ? 200 : 500,
      headers: { "Content-Type": "application/json" },
    }
  );
});
