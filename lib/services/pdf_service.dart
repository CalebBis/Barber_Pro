import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import '../data/database.dart';

class PdfService {
  static final _currencyFormat = NumberFormat.currency(locale: 'fr_FR', symbol: 'FC', decimalDigits: 0);
  static final _dateFormat = DateFormat('dd/MM/yyyy HH:mm');

  static pw.Widget _buildKpiCard(String title, String value) {
    return pw.Expanded(
      child: pw.Container(
        margin: const pw.EdgeInsets.symmetric(horizontal: 4),
        padding: const pw.EdgeInsets.all(12),
        decoration: pw.BoxDecoration(
          color: const PdfColor.fromInt(0xFF1E1E1E),
          borderRadius: pw.BorderRadius.circular(8),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(title, style: const pw.TextStyle(color: PdfColor.fromInt(0xFFAAAAAA), fontSize: 10)),
            pw.SizedBox(height: 8),
            pw.Text(value, style: pw.TextStyle(color: PdfColors.white, fontSize: 16, fontWeight: pw.FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  static Future<void> generateReceipt({
    required Client client,
    required Coiffeur coiffeur,
    required Visite visite,
    required String salonName,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text(salonName, style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Text(_dateFormat.format(visite.dateVisite)),
              pw.Divider(),
              pw.SizedBox(height: 10),
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                pw.Text('Client:'),
                pw.Text('${client.prenom} ${client.nom}'),
              ]),
              pw.SizedBox(height: 5),
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                pw.Text('Coiffeur:'),
                pw.Text(coiffeur.prenom),
              ]),
              pw.Divider(),
              pw.SizedBox(height: 10),
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                pw.Text('Prestation:'),
                pw.Text(visite.typeCoupe),
              ]),
              pw.SizedBox(height: 5),
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                pw.Text('Montant:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text(
                  visite.estGratuite ? 'GRATUIT - Fidelite' : _currencyFormat.format(visite.montant).replaceAll(RegExp(r'\s+'), ' '),
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
              ]),
              pw.SizedBox(height: 20),
              pw.Divider(),
              pw.Text('Merci de votre visite !', style: const pw.TextStyle(fontSize: 12)),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'recu_${client.nom}_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );
  }

  static Future<void> generateInventoryReport({
    required String periode,
    required List<Visite> visites,
    required List<Client> clients,
    required List<Coiffeur> coiffeurs,
    required int caTotal,
    required int passages,
    required int nouveauxClients,
    required int gratuitesUtilisees,
    required String salonName,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Text('Rapport $periode — $salonName', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Text('Genere le ${_dateFormat.format(DateTime.now())}'),
            pw.Divider(),
            pw.SizedBox(height: 10),
            pw.Text('Resume', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Row(
              children: [
                _buildKpiCard('Passages', passages.toString()),
                _buildKpiCard('CA total (FC)', _currencyFormat.format(caTotal).replaceAll(RegExp(r'\s+'), ' ')),
                _buildKpiCard('Gratuites utilisees', gratuitesUtilisees.toString()),
                _buildKpiCard('Nouveaux clients', nouveauxClients.toString()),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Divider(),
            pw.SizedBox(height: 10),
            pw.Text('Detail des visites', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.TableHelper.fromTextArray(
              headers: ['Date/Heure', 'Client', 'Coiffeur', 'Prestation', 'Montant', 'Type'],
              data: visites.map((v) {
                final c = clients.firstWhere(
                  (client) => client.id == v.clientId, 
                  orElse: () => Client(id: 0, nom: 'Inconnu', prenom: '', telephone: null, notes: null, totalCoupes: 0, gratuitesDisponibles: 0, dateCreation: DateTime.now())
                );
                final coif = coiffeurs.firstWhere(
                  (coiffeur) => coiffeur.id == v.coiffeurId, 
                  orElse: () => Coiffeur(id: 0, nom: 'Inconnu', prenom: '', specialite: null, actif: true, photoPath: null, nationalite: null, lieuNaissance: null, dateNaissance: null)
                );
                return [
                  _dateFormat.format(v.dateVisite),
                  '${c.prenom} ${c.nom}',
                  coif.prenom,
                  v.typeCoupe,
                  v.estGratuite ? '0 FC' : _currencyFormat.format(v.montant).replaceAll(RegExp(r'\\s+'), ' '),
                  v.estGratuite ? 'Fidelite' : 'Paye'
                ];
              }).toList(),
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'rapport_${periode}_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );
  }
}
