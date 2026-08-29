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
          color: PdfColors.white,
          border: pw.Border.all(color: PdfColors.black, width: 1),
          borderRadius: pw.BorderRadius.circular(8),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(title, style: const pw.TextStyle(color: PdfColors.black, fontSize: 10)),
            pw.SizedBox(height: 8),
            pw.Text(value, style: pw.TextStyle(color: PdfColors.black, fontSize: 16, fontWeight: pw.FontWeight.bold)),
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

    // Police monospace obligatoire pour alignement thermique
    final courier = pw.Font.courier();
    final courierBold = pw.Font.courierBold();

    // Format ticket thermique : 58mm largeur, 200mm hauteur max
    const pageFormat = PdfPageFormat(
      58 * PdfPageFormat.mm,
      200 * PdfPageFormat.mm,
      marginLeft: 2 * PdfPageFormat.mm,
      marginRight: 2 * PdfPageFormat.mm,
      marginTop: 3 * PdfPageFormat.mm,
      marginBottom: 3 * PdfPageFormat.mm,
    );

    // Séparateur style ticket de caisse (24 tirets pour 48mm Courier 8pt)
    const separateur = '------------------------';

    // Formatage du montant
    final montantTexte = visite.estGratuite
        ? 'GRATUIT - Fidelite'
        : '${NumberFormat('#,##0', 'fr_FR').format(visite.montant).replaceAll(',', ' ')} FC';

    // Formatage date
    final dateTexte = DateFormat('dd/MM/yyyy HH:mm').format(visite.dateVisite);

    // Noms
    final nomClient = '${client.prenom} ${client.nom}';
    final nomCoiffeur = '${coiffeur.prenom} ${coiffeur.nom}';

    // Type coupe formaté
    final typeCoupe = visite.typeCoupe.toLowerCase() == 'classique'
        ? 'Coupe classique'
        : 'Coupe premium';

    pdf.addPage(
      pw.Page(
        pageFormat: pageFormat,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            mainAxisSize: pw.MainAxisSize.min, // Prend juste la place du contenu
            children: [
              // Nom du salon — centré, gras, 10pt
              pw.Text(
                salonName,
                style: pw.TextStyle(font: courierBold, fontSize: 10),
                textAlign: pw.TextAlign.center,
              ),
              pw.SizedBox(height: 4),

              // Date
              pw.Text(
                dateTexte,
                style: pw.TextStyle(font: courier, fontSize: 8),
                textAlign: pw.TextAlign.center,
              ),
              pw.SizedBox(height: 6),

              // Séparateur
              pw.Text(separateur, style: pw.TextStyle(font: courier, fontSize: 8)),
              pw.SizedBox(height: 6),

              // Client
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Client:', style: pw.TextStyle(font: courierBold, fontSize: 8)),
                  pw.Text(nomClient, style: pw.TextStyle(font: courier, fontSize: 8)),
                ],
              ),
              pw.SizedBox(height: 4),

              // Coiffeur
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Coiffeur:', style: pw.TextStyle(font: courierBold, fontSize: 8)),
                  pw.Text(nomCoiffeur, style: pw.TextStyle(font: courier, fontSize: 8)),
                ],
              ),
              pw.SizedBox(height: 6),

              // Séparateur
              pw.Text(separateur, style: pw.TextStyle(font: courier, fontSize: 8)),
              pw.SizedBox(height: 6),

              // Prestation — sur 2 lignes pour éviter débordement
              pw.Text(
                'Prestation:',
                style: pw.TextStyle(font: courierBold, fontSize: 8),
              ),
              pw.Text(
                typeCoupe,
                style: pw.TextStyle(font: courier, fontSize: 8),
                textAlign: pw.TextAlign.center,
              ),
              pw.SizedBox(height: 4),

              // Montant — sur 2 lignes pour éviter coupure à droite
              pw.Text(
                'MONTANT:',
                style: pw.TextStyle(font: courierBold, fontSize: 9),
                textAlign: pw.TextAlign.left,
              ),
              pw.SizedBox(height: 2),
              pw.Text(
                montantTexte,
                style: pw.TextStyle(font: courierBold, fontSize: 11),
                textAlign: pw.TextAlign.center,
              ),
              pw.SizedBox(height: 6),

              // Séparateur
              pw.Text(separateur, style: pw.TextStyle(font: courier, fontSize: 8)),
              pw.SizedBox(height: 6),

              // Fidélité si applicable
              if (!visite.estGratuite) ...[
                pw.Text(
                  'Coupes totales: ${client.totalCoupes}',
                  style: pw.TextStyle(font: courier, fontSize: 8),
                  textAlign: pw.TextAlign.center,
                ),
                pw.SizedBox(height: 2),
                if (client.gratuitesDisponibles > 0)
                  pw.Text(
                    '${client.gratuitesDisponibles} coupe(s) gratuite(s) dispo!',
                    style: pw.TextStyle(font: courierBold, fontSize: 8),
                    textAlign: pw.TextAlign.center,
                  ),
                pw.SizedBox(height: 6),
              ],

              // Message de fin
              pw.Text(
                'Merci de votre visite!',
                style: pw.TextStyle(font: courierBold, fontSize: 9),
                textAlign: pw.TextAlign.center,
              ),
              pw.SizedBox(height: 2),
              pw.Text(
                'A bientot chez $salonName',
                style: pw.TextStyle(font: courier, fontSize: 8),
                textAlign: pw.TextAlign.center,
              ),
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
            pw.Text('Généré le ${_dateFormat.format(DateTime.now())}'),
            pw.Divider(),
            pw.SizedBox(height: 10),
            pw.Text('Résumé', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Row(
              children: [
                _buildKpiCard('Passages', passages.toString()),
                _buildKpiCard('CA total (FC)', _currencyFormat.format(caTotal).replaceAll(RegExp(r'\s+'), ' ')),
                _buildKpiCard('Gratuites utilisées', gratuitesUtilisees.toString()),
                _buildKpiCard('Nouveaux clients', nouveauxClients.toString()),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Divider(),
            pw.SizedBox(height: 10),
            pw.Text('Détail des visites', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
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
                  v.estGratuite ? 'Fidélité' : 'Payé'
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
