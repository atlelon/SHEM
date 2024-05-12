function [R] = coarseEnrichment(s,A)

    switch s.CSType
        case 'MS'
            R = [];
        case 'SHEM'
            R = createSpectralCoarseSpace(s,A);
        case 'alternating'
            R = createAlternatingCoarseSpace(s,A);
        case 'sine'
            R = createSineCoarseSpace(s,A);
        case 'hierarchical'
            R = createHierarchicalCoarseSpace(s,A);
        case 'adaptive'
            R = createAdaptiveCoarseSpace(s,A);
        otherwise
            error(['Unsupported coarse enrichment. Must be SHEM, alternating, ' ...
                'sine or hierarchical'])
    end
end
