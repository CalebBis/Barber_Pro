import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../providers/dashboard_provider.dart';
import '../../../providers/clients_provider.dart';
import '../../../data/database.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  String _chartFilter = '30 jours';

  @override
  Widget build(BuildContext context) {
    final dashboardData = ref.watch(dashboardProvider);
    final clientsData = ref.watch(clientsProvider);

    return Scaffold(
      body: dashboardData.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Erreur: $err')),
        data: (data) => clientsData.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Erreur: $err')),
          data: (clientsList) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Dashboard', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
                  const SizedBox(height: 24),
                  _buildKPIs(context, data),
                  const SizedBox(height: 24),
                  _buildChartCard(context),
                  const SizedBox(height: 24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildDerniersClients(context, data, clientsList)),
                      const SizedBox(width: 24),
                      Expanded(child: _buildCoiffeursActifs(context, data)),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildKPIs(BuildContext context, DashboardData data) {
    final format = NumberFormat.currency(locale: 'fr_FR', symbol: '', decimalDigits: 0);
    
    // Calcul des pourcentages / deltas
    int caDelta = data.caToday - data.caHier;
    double caPercent = data.caHier > 0 ? (caDelta / data.caHier) * 100 : (data.caToday > 0 ? 100.0 : 0.0);
    int passagesDelta = data.passagesToday - data.passagesHier;
    
    return Row(
      children: [
        _kpiCard(
          context, 
          'Clients total', 
          Icons.people_outline, 
          data.totalClients.toString(), 
          '+${data.nouveauxClientsMois} ce mois', 
          Colors.green,
        ),
        const SizedBox(width: 16),
        _kpiCard(
          context, 
          'Passages aujourd\'hui', 
          Icons.content_cut, 
          data.passagesToday.toString(), 
          '${passagesDelta >= 0 ? '+' : ''}$passagesDelta vs hier', 
          passagesDelta >= 0 ? Colors.green : Colors.red,
        ),
        const SizedBox(width: 16),
        _kpiCard(
          context, 
          'CA du jour (FC)', 
          Icons.monetization_on_outlined, 
          format.format(data.caToday).trim(), 
          '${caPercent >= 0 ? '+' : ''}${caPercent.toStringAsFixed(0)}% vs hier', 
          caPercent >= 0 ? Colors.green : Colors.red,
        ),
        const SizedBox(width: 16),
        _kpiCard(
          context, 
          'Gratuites en cours', 
          Icons.star_border, 
          data.gratuitesEnCours.toString(), 
          'sur ${data.totalClients} clients', 
          Colors.green,
        ),
      ],
    );
  }

  Widget _kpiCard(BuildContext context, String title, IconData icon, String value, String subtext, Color subtextColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.54), size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 14, fontWeight: FontWeight.w500),
                    maxLines: 2,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              value,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
            ),
            const SizedBox(height: 8),
            Text(
              subtext,
              style: TextStyle(color: subtextColor, fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Chiffre d'affaires — 30 derniers jours",
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Theme.of(context).dividerColor),
                ),
                child: Row(
                  children: ['30 jours', 'Mensuel', 'Annuel'].map((filter) {
                    final isSelected = _chartFilter == filter;
                    return GestureDetector(
                      onTap: () => setState(() => _chartFilter = filter),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? Theme.of(context).colorScheme.tertiary.withOpacity(0.15) : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          filter,
                          style: TextStyle(
                            color: isSelected ? Theme.of(context).colorScheme.tertiary : Theme.of(context).colorScheme.onSurface.withOpacity(0.54),
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          SizedBox(height: 32),
          SizedBox(
            height: 250,
            child: BarChart(
              BarChartData(
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 20000,
                  getDrawingHorizontalLine: (value) => FlLine(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.10), strokeWidth: 1),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) => Text('${(value / 1000).toInt()}k', style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.54), fontSize: 12)),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value % 3 != 0) return const SizedBox.shrink();
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text('${value.toInt()}/5', style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.54), fontSize: 12)), // Placeholder
                        );
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                barGroups: [
                  for (int i = 1; i <= 30; i++)
                    BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: (80000 + (i * 2000) % 50000).toDouble(), // Placeholder data
                          color: const Color(0xFF7C63EF), // Purple bar
                          width: 12,
                          borderRadius: BorderRadius.circular(2),
                        )
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDerniersClients(BuildContext context, DashboardData data, List<Client> clientsList) {
    final format = NumberFormat.currency(locale: 'fr_FR', symbol: 'FC', decimalDigits: 0);

    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Derniers clients', style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 20)),
          SizedBox(height: 16),
          if (data.derniersClients.isEmpty)
            Text('Aucune visite aujourd\'hui.', style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 14))
          else
            ...data.derniersClients.map((visite) {
              final client = clientsList.firstWhere(
                (c) => c.id == visite.clientId,
                orElse: () => Client(id: 0, nom: 'Inconnu', prenom: '', telephone: null, notes: null, totalCoupes: 0, gratuitesDisponibles: 0, dateCreation: DateTime.now())
              );
              
              final isGratuite = visite.estGratuite;
              final diff = DateTime.now().difference(visite.dateVisite);
              String timeAgo = diff.inMinutes < 60 ? '${diff.inMinutes} min' : '${diff.inHours}h';
              
              String initials = '${client.prenom.isNotEmpty ? client.prenom[0] : ""}${client.nom.isNotEmpty ? client.nom[0] : ""}';
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: const Color(0xFF2C4356), // Bleu sombre
                      child: Text(initials.toUpperCase(), style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Text('${client.prenom} ${client.nom}', style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 4),
                          Text('Il y a $timeAgo — ${isGratuite ? "gratuit" : format.format(visite.montant)}', style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 13)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isGratuite ? Colors.orange.withOpacity(0.1) : Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: isGratuite ? Colors.orange.withOpacity(0.3) : Colors.green.withOpacity(0.3)),
                      ),
                      child: Text(
                        isGratuite ? 'fidélité' : 'payé',
                        style: TextStyle(
                          color: isGratuite ? Colors.orange : Colors.green,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildCoiffeursActifs(BuildContext context, DashboardData data) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Coiffeurs actifs', style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 20)),
          SizedBox(height: 16),
          if (data.coiffeursActifs.isEmpty)
            Text('Aucun coiffeur actif.', style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 14))
          else
            ...data.coiffeursActifs.entries.map((entry) {
              final coiffeur = entry.key;
              final count = entry.value;
              String initials = '${coiffeur.prenom.isNotEmpty ? coiffeur.prenom[0] : ""}${coiffeur.nom.isNotEmpty ? coiffeur.nom[0] : ""}';
              
              // Déterminer une couleur en fonction de l'ID pour varier
              List<Color> bgColors = [
                const Color(0xFF1E4620), // Vert foncé
                const Color(0xFF5E452B), // Orange foncé / Marron
                const Color(0xFF5A2A3B), // Rose foncé
                const Color(0xFF2C4356), // Bleu foncé
              ];
              Color bgColor = bgColors[coiffeur.id % bgColors.length];
              Color textColor = Theme.of(context).colorScheme.onSurface; // On simplifie pour l'instant

              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: bgColor,
                      child: Text(initials.toUpperCase(), style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                     Text('${coiffeur.prenom} ${coiffeur.nom}', style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 16)),
                          SizedBox(height: 4),
                          Text('$count clients aujourd\'hui', style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 13)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}
